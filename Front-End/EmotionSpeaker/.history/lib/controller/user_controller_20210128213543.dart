import 'package:EmotionSpeaker/models/user.dart';
import 'package:get/state_manager.dart';

import 'package:EmotionSpeaker/repository/user_repository.dart';
import 'package:EmotionSpeaker/models/result.dart';

class UserController extends GetxController {
  String accessToken;
  String refreshToken;
  UserRepository userRepository = UserRepository();
  Future<Result> userLogin({User user}) async {
    Result result = await userRepository.userLogin(user: user);
    if (result is SuccessResult) {
      List list = result.getSuccessData();
      accessToken = list[0];
      refreshToken = list[1];
      return Result.success('Success');
    } else
      return result;
  }

  Future<Result> userRegister({User user}) async {
    Result result = await userRepository.userRegister(user: user);
    if (result is SuccessResult) {
      return await userLogin(user: user);
    } else
      return result;
  }

  Future<Result> userUpdate({User user}) async {
    try{
    Result result = await userRepository.userUpdate(
      user: user,
      accessToken: accessToken,
    );
    if (result is SuccessResult) {
      return await userLogin(user: user);
    } else
      return result;}catch(e){ return Result.error('Application Error');}
  }

  Future<Result> userLogut() async {
    tr
  }
}
