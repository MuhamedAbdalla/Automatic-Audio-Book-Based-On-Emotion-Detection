import 'package:EmotionSpeaker/common_widgets/text_input.dart';
import 'package:EmotionSpeaker/common_widgets/rounded_button.dart';
import 'package:EmotionSpeaker/constants/custom_colors.dart';
import 'package:EmotionSpeaker/constants/keys.dart';
import 'package:EmotionSpeaker/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:EmotionSpeaker/utils/sizing_extension.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.widthPercentage(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 15.heightPercentage(context),
              ),
              Center(
                child: Hero(
                  tag: '1',
                  child: Image.asset(
                    'assets/audiobook.png',
                    height: 30.widthPercentage(context),
                    width: 30.widthPercentage(context),
                  ),
                ),
              ),
              SizedBox(
                height: 1.heightPercentage(context),
              ),
              Center(
                child: Text(
                  'Book Beat',
                  style: TextStyle(
                    fontSize: 30.sp(context),
                    fontFamily: Keys.Araboto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5.heightPercentage(context),
              ),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 18.sp(context),
                  fontFamily: Keys.Araboto,
                ),
              ),
              TextInput(),
              SizedBox(
                height: 1.heightPercentage(context),
              ),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 18.sp(context),
                  fontFamily: Keys.Araboto,
                ),
              ),
              TextInput(
                obscure: true,
              ),
              SizedBox(
                height: 1.heightPercentage(context),
              ),
              SizedBox(
                height: 5.heightPercentage(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.widthPercentage(context),
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 15.sp(context),
                        fontFamily: Keys.Araboto,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 2.heightPercentage(context),
              ),
              Center(
                child: Text(
                  'Sign In with',
                  style: TextStyle(
                    fontSize: 15.sp(context),
                    fontFamily: Keys.Araboto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5.heightPercentage(context),
              ),
              RoundedButton(
                title: 'Facebook',
                buttoncolor: Color(0xff355ba9),
                onPreesed: signinwithFacebbok,
                textcolor: Colors.white,
              ),
              SizedBox(
                height: 2.heightPercentage(context),
              ),
              RoundedButton(
                title: 'Google',
                buttoncolor: Colors.grey.shade300,
                onPreesed: signinwithGoogle,
                textcolor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  signinwithGoogle() {
    Get.to(HomeScreen());
  }

  signinwithFacebbok() {
    Get.to(HomeScreen());
  }
}
