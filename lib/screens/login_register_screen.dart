import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_project/components/buttons.dart';
import 'package:login_project/screens/user_name_profile_picture_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/flash_messages.dart';
import '../components/input_error_message.dart';
import '../components/user_email_paswd_component.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final userEmail = TextEditingController();
  final userPassword = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userEmail.clear();
    userPassword.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E5E5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: width * 0.25, top: width * 0.25),
                          child: Image.asset(
                            'lib/image_assests/icons/at_app_icon.png',
                            scale: width * 0.012,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    //user email textfiled
                    EmailPasswordField(
                      controller: userEmail,
                      hintText: 'email',
                      obscureText: false,
                      textInputType: TextInputType.emailAddress,
                      emailholderheight: width * 0.13,
                      emailholderwidth: width,
                      emailPasswordFieldPadding:
                          EdgeInsets.only(bottom: width * 0.03),
                    ),

                    //user password textfield
                    EmailPasswordField(
                        controller: userPassword,
                        hintText: 'password',
                        obscureText: true,
                        textInputType: TextInputType.text,
                        emailholderheight: width * 0.13,
                        emailholderwidth: width,
                        emailPasswordFieldPadding:
                            EdgeInsets.only(bottom: width * 0.03)),

                    //forgot password
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: width * 0.1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //reset password function
                              passwordResetFunction(
                                  userEmail.text, width * 0.12, context);
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF676767),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //sign in button
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Button(
                              width: width,
                              height: width * 0.15,
                              boarderWidth: 0,
                              buttonPadding: EdgeInsets.only(
                                top: width * 0.3 / 8,
                              ),
                              elevation: 5,
                              fontSize: 16,
                              boarderColor: const Color(0xFFC3C1C1),
                              backgroundColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              buttonName: 'GO..',
                              borderRadius: BorderRadius.circular(10),
                              function: () {
                                registerUserFunction(userEmail.text,
                                    userPassword.text, width * 0.12, context);
                              } //sing function here,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //password reset function
  Future<void> passwordResetFunction(
      String email, double msgheight, context) async {
    if (email.isNotEmpty && EmailValidator.validate(email) == false) {
      String msg = 'Enter Valid email';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (email.isEmpty) {
      String msg = 'Enter Email';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: userEmail.text);
        const FlashMessages(
          imagePath:
              'lib/image_assests/icons/flash_messege_icons/email_icon.png',
          text1: 'Request sent',
          text2: 'Check your email..!',
          imageColor: Color(0xFF00345F),
          backGroundColor: Color(0xFF2A9DFA),
          fontColor: Color(0xFF00345F),
          imageSize: 10,
          duration: Duration(seconds: 5),
        ).flashMessageFunction(context);
      } on FirebaseAuthException catch (e) {
        // Handle the error or display an error message to the user
        if (e.code == 'network-request-failed') {
          //network lost
          const FlashMessages(
            imagePath:
                'lib/image_assests/icons/flash_messege_icons/request_error_icon.png',
            text1: 'Oops!',
            text2: 'Connection Error..',
            imageColor: Color(0xFF650903),
            backGroundColor: Colors.red,
            fontColor: Color(0xFF650903),
            imageSize: 11,
            duration: Duration(seconds: 5),
          ).flashMessageFunction(context);
        } else if (e.code == 'too-many-requests') {
          //too many requests device bocked!!
          const FlashMessages(
            imagePath:
                'lib/image_assests/icons/flash_messege_icons/bocked-phone_icon.png',
            text1: 'Device bocked!',
            text2: 'Due to too many Requests',
            imageColor: Color(0xFF490156),
            backGroundColor: Color(0xFFE660FE),
            fontColor: Color(0xFF490156),
            imageSize: 3,
            duration: Duration(seconds: 5),
          ).flashMessageFunction(context);
        }
      }
    }
  }

//user registration & login
  void registerUserFunction(
      String email, String password, double msgheight, context) async {
    //implementing shared preference
    SharedPreferences preferense = await SharedPreferences.getInstance();
    FirebaseAuth auth = FirebaseAuth.instance;

    if (email.isNotEmpty && EmailValidator.validate(email) == false) {
      String msg = 'Enter Valid email';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (password.isEmpty && email.isEmpty) {
      String msg = 'Enter Email & Password';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (password.isEmpty && email.isNotEmpty) {
      String msg = 'Enter Password';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (password.length < 6) {
      String msg = 'Password minimum 6';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (password.isNotEmpty && email.isEmpty) {
      String msg = 'Enter Email';
      InputErrorMessage(
              errorMessage: msg,
              height: msgheight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else {
      try {
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        // User is already registered, perform sign-in
        await auth.signInWithEmailAndPassword(
            email: userEmail.text, password: userPassword.text);

        preferense.setString('UserEmail', email);
        preferense.setString('UserPassword', password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const UserNamePictureScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "wrong-password") {
          const FlashMessages(
            imagePath:
                'lib/image_assests/icons/flash_messege_icons/password_wrong_icon.png',
            text1: 'Oops!',
            text2: 'Wrong Password..',
            imageColor: Color(0xFF004602),
            backGroundColor: Color(0xFF22FF2A),
            fontColor: Color(0xFF004602),
            imageSize: 11,
            duration: Duration(seconds: 5),
          ).flashMessageFunction(context);
        } else if (e.code == 'user-not-found') {
          //if no user found , register as new user
          await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          // Registration successful message
          const FlashMessages(
            imagePath:
                'lib/image_assests/icons/flash_messege_icons/user_regiter_icon.png',
            text1: 'Welcome!',
            text2: 'Successful registration',
            imageColor: Colors.white,
            backGroundColor: Colors.black,
            fontColor: Colors.white,
            imageSize: 11,
            duration: Duration(seconds: 4),
          ).flashMessageFunction(context);
          //saving user email and password in shared preference
          preferense.setString('UserEmail', email);
          preferense.setString('UserPassword', password);

          // Navigate to the home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const UserNamePictureScreen()),
          );
        } else if (e.code == 'network-request-failed') {
          const FlashMessages(
            imagePath:
                'lib/image_assests/icons/flash_messege_icons/request_error_icon.png',
            text1: 'Oops!',
            text2: 'Connection Error..',
            imageColor: Color(0xFF650903),
            backGroundColor: Colors.red,
            fontColor: Color(0xFF650903),
            imageSize: 10,
            duration: Duration(seconds: 5),
          ).flashMessageFunction(context);
        }
      }
    }
  }
}
