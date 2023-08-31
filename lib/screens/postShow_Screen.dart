import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_project/components/navigation_bar.dart';
import '../components/flash_messages.dart';

// ignore: must_be_immutable
class PostShowScreen extends StatefulWidget {
  String? postId, postURL;

  PostShowScreen({super.key, required this.postId, required this.postURL});

  @override
  State<PostShowScreen> createState() => _PostShowScreenState();
}

class _PostShowScreenState extends State<PostShowScreen> {
  bool pushbuttonState = false;
  String? userPostUrl;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        // final height = constraints.maxHeight;

        return WillPopScope(
          onWillPop: () async {
            // Handle the back button press here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 4,
                      )),
            ); // This will navigate back to the previous screen

            return false;
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, right: 5),
                      child: GestureDetector(
                        onTap: () {
                          print('object');
                          postDeleteFunction(width);
                        },
                        child: Transform.rotate(
                          angle: -pi /
                              2, // Rotating the text by 90 degrees counter-clockwise
                          child: Text(
                            '...',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, right: width * 0.015, left: width * 0.015),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(widget.postURL!)),
                  )
                ],
              ),
              if (pushbuttonState == true)
                Container(
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.5)),
                  child: Stack(
                    children: [
                      Container(
                        width: width / 10,
                        height: width / 10,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          color: Colors.black,
                          strokeWidth: width / 10,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      })),
    );
  }

  Future<void> postDeleteFunction(double width) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: 3),
      content: ElevatedButton(
        onPressed: () async {
          setState(() {
            pushbuttonState == true;
          });

          try {
            FirebaseFirestore currentPostSnapshot =
                await FirebaseFirestore.instance;

            //delete post from all user post collection
            currentPostSnapshot
                .collection('AllUserPostsDetails')
                .doc(widget.postId)
                .delete();

            final postRef = await FirebaseStorage.instance
                .ref()
                .child('AllUsersPostImages')
                .child(widget.postId! + '.jpg');

            postRef.delete();

            //after successfull uploading it redirects to home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 4,
                      )),
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'network-request-failed') {
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
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width, 50),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.white, width: 2)),
          backgroundColor: Colors.transparent,
        ),
        child: Text('Delete..',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    ));
  }
}
