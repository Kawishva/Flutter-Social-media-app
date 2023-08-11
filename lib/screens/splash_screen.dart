import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_project/components/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/flash_messages.dart';
import 'login_register_screen.dart';

class SplashScrean extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SplashScrean({Key? key});

  @override
  State<SplashScrean> createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  @override
  void initState() {
    super.initState();
    userSignInFunction(context);
  }

  void userSignInFunction(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('UserEmail');
    String? userPassword = prefs.getString('UserPassword');

    // Sign in with email and password
    if (userEmail != null && userPassword != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        // Sign-in successful, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NavigationBarComponent()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle timeout exception as a connection error
        if (e.code == 'network-request-failed') {
          const FlashMessages(
            imagePath:
                'lib/image_assests/icons/flash_messege_icons/request_error_icon.png',
            text1: 'Oops!',
            text2: 'Connection Error..',
            imageColor: Color(0xFF650903),
            backGroundColor: Colors.red,
            fontColor: Color(0xFF650903),
            imageSize: 11,
            duration: Duration(seconds: 4),
          ).flashMessageFunction(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginRegisterScreen()),
          );
        }
        if (e.code == 'user-not-found') {
          //no user found in database
          // Navigate to the home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginRegisterScreen()),
          );
        }
      }
    } else {
      //navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Image.asset(
          'lib/image_assests/icons/at_app_icon.png',
          scale: 5,
          color: Colors.black,
        ),
      )),
    );
  }
}
