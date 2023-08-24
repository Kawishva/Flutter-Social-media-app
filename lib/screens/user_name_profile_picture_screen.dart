import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_project/components/navigation_bar.dart';
import '../components/flash_messages.dart';
import '../components/input_error_message.dart';
import '../components/show_dialog_request.dart';

class UserNamePictureScreen extends StatefulWidget {
  const UserNamePictureScreen({super.key});

  @override
  State<UserNamePictureScreen> createState() => _UserNamePictureScreenState();
}

class _UserNamePictureScreenState extends State<UserNamePictureScreen> {
  File? imageFile;
  final userName = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E5E5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Center(
              child: Column(
                children: [
                  //user profile picture
                  Padding(
                    padding:
                        EdgeInsets.only(top: width * 0.3, bottom: width * 0.15),
                    child: GestureDetector(
                      onTap: () {
                        //set profile picture function here
                        ShowDialogRequest(
                          //Camera or Gallery request
                          button1: 'Camera',
                          button2: 'Gallery',
                          button1Function: () {
                            //camera access
                            cameraAccessFunction();
                            Navigator.pop(context);
                          },
                          button2Function: () {
                            //Gallery access
                            galloryAccessFunction();
                            Navigator.pop(context);
                          },
                          imageAsset:
                              'lib/image_assests/icons/image_picker_icon.png',
                        ).imagePickerFunction(context);
                      },
                      child: CircleAvatar(
                        radius: width * 0.2,
                        backgroundImage: imageFile == null
                            ? AssetImage(
                                'lib/image_assests/icons/avatar_DP_icon.png')
                            : Image.file(imageFile!).image,
                      ),
                    ),
                  ),
                  //user profile picture end

                  //user profile name name enter field start
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                    child: Wrap(
                      children: [
                        TextField(
                          textAlign: TextAlign.center,
                          controller: userName,
                          style: TextStyle(
                              fontSize: width * 0.14 / 3,
                              overflow: TextOverflow.visible),
                          maxLength: 10,
                          decoration: InputDecoration(
                              hintText: 'Enter Profile Name',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(5)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              )),
                        ),
                      ],
                    ),
                  ),

                  //user profile name enter field end

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.2, vertical: width * 0.01),
                    child: Wrap(
                      children: [
                        TextField(
                          textAlign: TextAlign.center,
                          controller: description,
                          style: TextStyle(
                              fontSize: width * 0.12 / 3,
                              overflow: TextOverflow.visible),
                          maxLength: 10,
                          decoration: InputDecoration(
                              hintText: 'Description',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(5)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              )),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: width * 0.2),
                      child: Container(
                        width: width * 0.2,
                        height: width * 0.2,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          onPressed: () {
                            //upload data to fire store function here
                            pushUserDataToFireStoreFunction(
                                userName.text, width * 0.12);
                          },
                          child: const Text(
                            'Go....',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

//camera access function
  Future<void> cameraAccessFunction() async {
//image get function
    XFile? pickerFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickerFile == null) {
      return;
    }
//image crop function
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickerFile.path, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    } else {
      return;
    }
  }

//gallery access function
  Future<void> galloryAccessFunction() async {
//image get function
    XFile? pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }
//image crop function
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickerFile.path, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    } else {
      return;
    }
  }

  //push user name and profile picture to firebase function
  Future<void> pushUserDataToFireStoreFunction(
      String userName, double mSGHeight) async {
    User? currentUser = FirebaseAuth.instance
        .currentUser; // Get the currently signed-in user from Firebase Authentication

    if (userName.isEmpty && imageFile == null) {
      String msg = 'Picture? and Name?';
      InputErrorMessage(
              errorMessage: msg,
              height: mSGHeight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (userName.isEmpty) {
      String msg = 'Enter User Name';
      InputErrorMessage(
              errorMessage: msg,
              height: mSGHeight,
              erroMSGPadding: EdgeInsets.symmetric(
                  horizontal: msg.length.toDouble() * 11 / 10))
          .errorMessageFunction(context);
    } else if (userName.isNotEmpty && imageFile == null) {
      try {
        //save user name on firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            . //currentUser!.uid
            get()
            .then((snapshot) async {
          if (snapshot.exists) {
            //if user had a previous account
            FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .update({
              'ProfileName': userName,
              'Description': description.text.isNotEmpty ? description.text : ''
            });

            //directing to navigation bar component
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 0,
                      )),
            );
          } else {
            //save user name on firestore
            FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .set({
              'ProfileName': userName,
              'DpURL': '',
              'PostIDs': FieldValue.arrayUnion([]),
              'StoryIDs': FieldValue.arrayUnion([]),
              'requestId': FieldValue.arrayUnion([]),
              'Description': description.text.isNotEmpty ? description.text : ''
            });

            await FirebaseFirestore.instance
                .collection('AllUserIDs')
                .doc('UserIDs')
                .update({
              'UserIDs': FieldValue.arrayUnion([currentUser.uid]),
            });

            //directing to navigation bar component
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 0,
                      )),
            );
          }
        });
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
    } else if (userName.isNotEmpty && imageFile != null) {
      try {
        // Create a Firebase Storage reference for the current user's profile image
        final profileImageReference = FirebaseStorage.instance
            .ref()
            .child(currentUser!.uid + '| |DP')
            .child('userDP.jpg');

        // Upload the profile image file using putFile()
        await profileImageReference.putFile(imageFile!);
        //download image usrl in storage
        String imageURL = await profileImageReference.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            . //currentUser!.uid
            get()
            .then((snapshot) async {
          if (snapshot.exists) {
            //if user had a previous account
            FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .update({
              'ProfileName': userName,
              'DpURL': imageURL, //saving image usrl in real time db:firestore
              'Description': description.text.isNotEmpty ? description.text : ''
            });

            //directing to navigation bar component
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 0,
                      )),
            );
          } else {
            //save user name on firestore
            FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .set({
              'ProfileName': userName,
              'DpURL': imageURL, //saving image usrl in real time db:firestore
              'PostIDs': FieldValue.arrayUnion([]),
              'StoryIDs': FieldValue.arrayUnion([]),
              'requestId': FieldValue.arrayUnion([]),
              'Description': description.text.isNotEmpty ? description.text : ''
            });

            await FirebaseFirestore.instance
                .collection('AllUserIDs')
                .doc('UserIDs')
                .update({
              'UserIDs': FieldValue.arrayUnion([currentUser.uid]),
            });

            //directing to navigation bar component
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 0,
                      )),
            );
          }
        });
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
    }
  }
}
