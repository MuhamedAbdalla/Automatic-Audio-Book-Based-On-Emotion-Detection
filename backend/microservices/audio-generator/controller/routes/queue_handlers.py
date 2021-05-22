from config import *
from .audio_order import cx_queue, tts_queue
from core.entities import parse_book, Sentence
from core.usecases import update_audio_order, add_audio_file, get_audio_order, insert_sentences, get_sentences

import time
import threading
import requests
import os
from pydub import AudioSegment

FRAGMENT_AUDIO_PATH = "fragment.wav"


class QueuesHandlers:
    __lock = threading.Lock()

    @staticmethod
    def run_queue_handlers():
        def cx_queue_handler():
            while True:
                if cx_queue:
                    QueuesHandlers.__lock.acquire()
                    order_id, sentences = cx_queue[0]
                    QueuesHandlers.__lock.release()
                    sentences = " ".join(sentences)
                    sentences, chars_names, scripts = parse_book(sentences)
                    sentences = ' '.join([' '.join(st) for st in sentences])
                    sentences = ''.join([' ', sentences, ' '])
                    update_audio_order(id=order_id, audio_link=None, chars_names=chars_names, scripts=scripts, sentences=sentences)
                    QueuesHandlers.__lock.acquire()
                    cx_queue.popleft()
                    QueuesHandlers.__lock.release()
                else:
                    time.sleep(10)  #  sec

        def tts_queue_handler():
            while True:
                if tts_queue:
                    QueuesHandlers.__lock.acquire()
                    id, chars_audios = tts_queue[0]
                    QueuesHandlers.__lock.release()
                    sentences_list = get_sentences_list(id)

                    if chars_audios is None:
                        sentences = ' '.join([sentence.text for sentence in sentences_list])
                        with requests.get(url=MOZILLA_ABS_ENDPOINT,
                                         data={REQ_MOZILLA_TSS_TEXT_KEY_NAME: sentences}) as r:
                            r.raise_for_status()
                            local_filename = 'temp_audio.wav'
                            with open(local_filename, 'wb') as f:
                                for chunk in r.iter_content(chunk_size=8192):
                                    f.write(chunk)
                            add_audio_file(id, local_filename)
                    else:
                        audio_files = []
                        for sentence in sentences_list:
                            if sentence.character_name is None or sentence.character_name not in chars_audios:
                                with requests.get(url=MOZILLA_ABS_ENDPOINT,
                                                  data={REQ_MOZILLA_TSS_TEXT_KEY_NAME: sentence.text}) as r:
                                    r.raise_for_status()
                                    local_filename = str(id) + str(sentence.pos) + '.wav'
                                    audio_files.append(local_filename)
                                    with open(local_filename, 'wb') as f:
                                        for chunk in r.iter_content(chunk_size=8192):
                                            f.write(chunk)
                            else:
                                with requests.get(url=TTS_ABS_ENDPOINT,
                                                  files={REQ_TSS_FILE_KEY_NAME: open(chars_audios[sentence.character_name], "rb")},
                                                  data={
                                                      REQ_TSS_TEXT_KEY_NAME: sentence.text,
                                                      REQ_TSS_FILE_SIZE_KEY_NAME: os.path.getsize(chars_audios[sentence.character_name])
                                                  }) as r:
                                    local_filename = str(id) + str(sentence.pos) + '.wav'
                                    audio_files.append(local_filename)
                                    with open(local_filename, 'wb') as f:
                                        for chunk in r.iter_content(chunk_size=8192):
                                            f.write(chunk)

                        file_path = merge_audios(audio_files, id)
                        add_audio_file(id, file_path)
                        for char in chars_audios:
                            audio_files.append(chars_audios[char])
                        for path in audio_files:
                            os.remove(path)
                    QueuesHandlers.__lock.acquire()
                    tts_queue.popleft()
                    QueuesHandlers.__lock.release()
                else:
                    time.sleep(10)  # sec

        thread = threading.Thread(target=cx_queue_handler, daemon=True)
        thread.start()
        thread = threading.Thread(target=tts_queue_handler, daemon=True)
        thread.start()


def get_sentences_list(req_id):
    audio_req = get_audio_order(req_id)
    sentences_list = getList(audio_req.text, audio_req.scripts)
    return sentences_list


def isValid(char, prev):
    return 'A' <= char <= 'Z' and not ('a' <= prev <= 'z' or 'A' <= prev <= 'Z')


def getChar(text, script, prev):
    mn = 2 * 10**18
    char = None
    for i in script:
        for j in script[i]:
            if j[1] < mn and j[0] == text and mn > prev:
                mn = j[1]
                char = i
                break
    if char is not None:
        return char, mn
    return None, None


def getList(sentence, script):
    res: [Sentence] = []
    cur_text = str()
    i = 0
    sent_pos = 0
    prev = -1
    while i < len(sentence):
        if sentence[i] == "'" and isValid(sentence[i + 1], sentence[i - 1]):
            if len(cur_text.strip()) > 0:
                res.append(Sentence(text=cur_text, char_name=None, pos=sent_pos))
                cur_text = ""
                sent_pos += 1
            start = i + 1
            end = sentence.find("' ", i + 1)
            if end == -1:
                end = sentence.find("'\n", i + 1)
            if start <= end:
                cur_sentence = sentence[start:end]
                char, tmp = getChar(cur_sentence, script, prev)
                if tmp is not None:
                    prev = tmp
                if len(cur_text.strip()) > 0:
                    res.append(Sentence(text=cur_text, char_name=char, pos=sent_pos))
                    sent_pos += 1
                i = end + 1
        else:
            cur_text += sentence[i]
        i += 1
    if len(cur_text.strip()) > 0:
        res.append(Sentence(text=cur_text, char_name=None, pos=sent_pos))
        sent_pos += 1
    return res


def merge_audios(listOfPath, id):
    files_path = listOfPath
    fragment_audio = AudioSegment.from_file(os.path.join(FRAGMENT_AUDIO_PATH))
    fermentable = list()
    combined = AudioSegment.empty()
    for path in files_path:
        audiophile = AudioSegment.from_file(path)
        fermentable.extend([audiophile, fragment_audio])
    for fame in fermentable:
        combined += fame
    combined.export("output" + id + ".wav", format="wav")
    return "output" + id + ".wav"