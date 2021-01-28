import 'package:EmotionSpeaker/constants/shared_preferences_keys.dart';
import 'package:EmotionSpeaker/models/user.dart';
import 'package:EmotionSpeaker/utils/shared_pref.dart';
import 'package:get/state_manager.dart';

import 'package:EmotionSpeaker/repository/user_repository.dart';
import 'package:EmotionSpeaker/models/result.dart';

class UserController extends GetxController {
  String accessToken;
  String refreshToken;
  UserRepository userRepository = UserRepository();
  User user;
  Future<Result> openApp() async {
    await SharedPref.initialize();
    bool login = SharedPref.pref.getBool(SharedPreferencesKeys.Login) ?? false;
    if (login) {
      String email = SharedPref.pref.getString(SharedPreferencesKeys.Email);
      String password =
          SharedPref.pref.getString(SharedPreferencesKeys.Password);
      return await userLogin(user: User());
    } else
      return false;
  }

  Future<Result> userLogin({User user}) async {
    try {
      Result result = await userRepository.userLogin(user: user);
      if (result is SuccessResult) {
        List list = result.getSuccessData();
        accessToken = list[0];
        refreshToken = list[1];
        Result result2 = await getUser();
        if (result2 is SuccessResult)
          return Result.success('Success');
        else
          return result2;
      } else
        return result;
    } catch (e) {
      return Result.error('Application Error');
    }
  }

  Future<Result> userRegister({User user}) async {
    try {
      Result result = await userRepository.userRegister(user: user);
      if (result is SuccessResult) {
        return await userLogin(user: user);
      } else
        return result;
    } catch (e) {
      return Result.error('Application Error');
    }
  }

  Future<Result> getUser({User user}) async {
    try {
      Result result = await userRepository.getUser(accessToken: accessToken);
      if (result is SuccessResult) {
        user = result.getSuccessData();
        return Result.success('Success');
      } else
        return result;
    } catch (e) {
      return Result.error('Application Error');
    }
  }

  Future<Result> userUpdate({User user}) async {
    try {
      Result result = await userRepository.userUpdate(
        user: user,
        accessToken: accessToken,
      );
      if (result is SuccessResult) {
        return Result.success('Success');
      } else
        return result;
    } catch (e) {
      return Result.error('Application Error');
    }
  }

  Future<Result> userLogut() async {
    try {
      Result result = await userRepository.userLogut(accessToken: accessToken);
      if (result is SuccessResult) {
        accessToken = null;
        refreshToken = null;
      }
      return result;
    } catch (e) {
      return Result.error('Application Error');
    }
  }
}
