def build_update_audio_order(update_audio_order_db):
    def update_audio_order(id, audio_link, chars_names, scripts) -> bool:
        return update_audio_order_db(id, audio_link, chars_names, scripts)
    return update_audio_order