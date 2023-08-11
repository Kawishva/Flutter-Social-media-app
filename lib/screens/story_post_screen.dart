import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/flash_messages.dart';
import '../components/navigation_bar.dart';
import '../components/show_dialog_request.dart';

class StoryPostScreen extends StatefulWidget {
  const StoryPostScreen({super.key});

  @override
  State<StoryPostScreen> createState() => _StoryPostScreenState();
}

class _StoryPostScreenState extends State<StoryPostScreen> {
  final userText =
      TextEditingController(); //taking text to text field in post screen
  final userDialogText =
      TextEditingController(); // taking text to text field in story screen dialog window

  int storyPostState = 0; // indexstach index changer
  File? storyPostImage; //imageholder variable
  String? imageDescription = null; //user description text holder
  bool storyIsOnState = true,
      pushbuttonState =
          false; //story icon and firebase post or story upload state changer

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //when screen is closed this reset alll the states
    userText.clear();
    storyPostImage = null;
    imageDescription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        // final height = constraints.maxHeight;
        return Stack(
          //1.IndexStack
          //2.Story & Post button holder
          //3.Screen close button and upload icon
          //4.Camera & Gallory access buttons
          children: [
            IndexedStack(
              index: storyPostState,
              children: [
                Center(
                  //index=0(default state)
                  //text input field for story display
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 5 / 100),
                        child: Center(
                          child: Wrap(
                            //for  current index =0
                            children: [
                              TextField(
                                textAlign: TextAlign.center,
                                controller: userText,
                                maxLines: null,
                                style: TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.visible),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(5)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (pushbuttonState == true)
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5)),
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
                ),
                Stack(
                  //index=1
                  //when in poststate is true, if post user set a image then storypost state changes to state 1
                  //then theat image sets in this holder
                  //or otherwise user goto post screen then iths enables and shows the set image
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: width * 3.5 / 10, left: 2, right: 2),
                        child: Container(
                            width: width,
                            height: width,
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            child: storyPostImage == null
                                ? null
                                : Image.file(
                                    storyPostImage!,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit
                                        .contain, //set post or story image
                                  )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: width * 1.1,
                                left: width / 17,
                                right: width / 17),
                            child: GestureDetector(
                              onTap: () {
                                //this is user description text input dialog box launcher
                                //implemented in below
                                dialogRequestFunction(width);
                              },
                              child: Container(
                                //this hold the user description
                                width: width,
                                height: 180,
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: ListView(children: [
                                  Text(
                                    //if post image is null then no descrioption option
                                    storyPostImage == null
                                        ? ''
                                        : imageDescription == null ||
                                                imageDescription!.isEmpty
                                            ? 'Description'
                                            : imageDescription!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.fade),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ],
            ),
            Align(
              //Post & Story button holder
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: width * 7 / 100, right: width * 2.5 / 100),
                child: Container(
                  width: width * 0.35,
                  height: width * 0.1,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            //when Story button is tapped
                            storyPostImage = null;
                            userDialogText.clear();
                            imageDescription = null;
                            storyPostState = 0;
                            storyIsOnState = true;
                          });
                        },
                        child: Text(
                          'Story',
                          style: TextStyle(
                              color: storyIsOnState == true
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 4 / 100),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      GestureDetector(
                        onTap: () {
                          //when POst button is tapped
                          setState(() {
                            storyPostState = 1;
                            imageDescription = null;
                            userDialogText.clear();
                            storyIsOnState = false;
                            userText.clear();
                            storyPostImage = null;
                          });
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
                              galleryAccessFunction();
                              Navigator.pop(context);
                            },
                            imageAsset:
                                'lib/image_assests/icons/image_picker_icon.png',
                          ).imagePickerFunction(context);
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(
                              color: storyIsOnState == false
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 4 / 100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              //upload button
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                    top: width * 9 / 100, right: width * 7 / 100),
                child: IconButton(
                  //firebase upload implementation here
                  onPressed: () {
                    postUploadFunction();
                  },
                  icon: Icon(
                    Icons.send_outlined,
                    color: Colors.black,
                    size: width * 12 / 100,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: width * 0.00099,
                        blurRadius: width * 0.0099,
                        offset: Offset(
                          3,
                          width * 0.008,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              //Story post screen close button here
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(top: width * 9 / 100, right: width / 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationBarComponent()),
                    );
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                    size: width * 11 / 100,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: width * 0.00099,
                        blurRadius: width * 0.0099,
                        offset: Offset(
                          -3,
                          width * 0.008,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              //camera and gallery buttons here
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: width * 7 / 100, left: width * 2.5 / 100),
                child: Container(
                  width: width * 0.35,
                  height: width * 0.1,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            //when camera button is tapped
                            //camera access function
                            cameraAccessFunction();
                            userText.clear();
                            storyPostState = 1;
                          });
                        },
                        child: Icon(
                          Icons.photo_camera_rounded,
                          size: width * 0.08,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            //when gallery button is tapped
                            //gallery access function
                            galleryAccessFunction();
                            userText.clear();
                            storyPostState = 1;
                          });
                        },
                        child: Icon(
                          Icons.photo_library,
                          size: width * 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  //camera access function
  Future<void> cameraAccessFunction() async {
    XFile? pickerFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickerFile == null) {
      setState(() {
        storyPostState = 0;
      });
      return;
    } // User canceled the operation.

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickerFile.path,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (croppedImage != null) {
      setState(() {
        // storyPostState = 2;
        storyPostImage = File(croppedImage.path);
      });
    } else {
      setState(() {
        storyPostState = 0;
      });
      return;
    }
  }

  //gallery access function
  Future<void> galleryAccessFunction() async {
    XFile? pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      setState(() {
        storyPostState = 0;
      });
      return;
    } // User canceled the operation.

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickerFile.path,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (croppedImage != null) {
      setState(() {
        // storyPostState = 2;
        storyPostImage = File(croppedImage.path);
      });
    } else {
      setState(() {
        storyPostState = 0;
      });
      return;
    }
  }

  void dialogRequestFunction(double width) {
    if (storyPostImage != null) {
      showDialog(
          //dialog tab for enter the description for post or story image
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              content: Container(
                width: width,
                height: 300,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      width: width,
                      height: 275,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: userDialogText,
                        maxLines: null,
                        style: TextStyle(
                            fontSize: 15, overflow: TextOverflow.fade),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(5)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      //this button is in side the dialogbox but top on the
                      //user description enter field.
                      //this sets the user enterd description to description text and clear the
                      //user dialod text controller
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: FloatingActionButton(
                            elevation: 10,
                            backgroundColor: Colors.white,
                            onPressed: () {
                              imageDescription = userDialogText.text;
                              // userDialogText.clear();
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.add_box_outlined,
                              color: Colors.black,
                              size: 30,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  Future<void> postUploadFunction() async {
    String? userName;
    User? currentUser = FirebaseAuth.instance
        .currentUser; // Get the currently signed-in user from Firebase Authentication
    SharedPreferences preferense = await SharedPreferences.getInstance();

    String? postImageId, storyId;
    int postIdNumber, storyIdNumber;

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.exists) {
          setState(() {
            userName = snapshot.data()![
                'ProfileName']; //retrieving username from firebase firestore
          });

          //when user sharing a story
          if (storyIsOnState == true) {
            // user sharing text story
            if (userText.text.isNotEmpty && storyPostImage == null) {
              setState(() {
                pushbuttonState = true;
                if (preferense.getInt('storyId') == null) {
                  storyIdNumber = 0;
                  storyId = currentUser.uid.toString() +
                      storyIdNumber.toString(); //creating a storyId
                  preferense.setInt('storyId',
                      storyIdNumber); //saving new storyIdnumber in sharede pref
                } else {
                  storyIdNumber = preferense.getInt('storyId')!;
                  storyIdNumber++; //increasing numer by 1
                  storyId = currentUser.uid.toString() +
                      storyIdNumber.toString(); //creating a storyId
                  preferense.setInt('storyId',
                      storyIdNumber); //saving new storyIdnumber in sharede pref
                }
              });
              //save details in firestore
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser.uid)
                  .update({
                'StoryIDs': FieldValue.arrayUnion([
                  storyId
                ]) //saving story Ids in real time db:firestore to an array
              });

              //save details in firestore
              await FirebaseFirestore.instance
                  .collection('AllUserStories')
                  .doc('UserStoryIds')
                  .update({
                'StoryIDs': FieldValue.arrayUnion([
                  storyId
                ]) //saving story Ids in real time db:firestore to an array
              });

              //making user stories details collection
              await FirebaseFirestore.instance
                  .collection('AllUserStoriesDetails')
                  .doc(storyId)
                  .set({
                //saving posts detatils
                'UserID': currentUser.uid,

                'TextStory': userText.text,
              });
            } // user sharing image story
            else if (userText.text.isEmpty && storyPostImage != null) {
              setState(() {
                pushbuttonState = true;
                if (preferense.getInt('storyId') == null) {
                  storyIdNumber = 0;
                  storyId = currentUser.uid.toString() +
                      storyIdNumber.toString(); //creating a storyId
                  preferense.setInt('storyId',
                      storyIdNumber); //saving new storyIdnumber in sharede pref
                } else {
                  storyIdNumber = preferense.getInt('storyId')!;
                  storyIdNumber++; //increasing numer by 1
                  storyId = currentUser.uid.toString() +
                      storyIdNumber.toString(); //creating a storyId
                  preferense.setInt('storyId',
                      storyIdNumber); //saving new storyIdnumber in sharede pref
                }
              });
              //save details in firestore
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser.uid)
                  .update({
                'StoryIDs': FieldValue.arrayUnion([
                  storyId
                ]) //saving story Ids in real time db:firestore to an array
              });

              //save details in firestore
              await FirebaseFirestore.instance
                  .collection('AllUserStories')
                  .doc('UserStoryIds')
                  .update({
                'StoryIDs': FieldValue.arrayUnion([
                  storyId
                ]) //saving story Ids in real time db:firestore to an array
              });

              final postRef = await FirebaseStorage.instance
                  .ref()
                  .child('AllUsersPostImages')
                  .child(userName! + '|' + DateTime.now().toString() + '.jpg');

              // Upload the post file using putFile()
              await postRef.putFile(storyPostImage!);

              //download post usrl in storage
              String storyimageURL = await postRef.getDownloadURL();

              //making user stories details collection
              await FirebaseFirestore.instance
                  .collection('AllUserStoriesDetails')
                  .doc(storyId)
                  .set({
                //saving Image Story detatils
                'UserID': currentUser.uid,
                'ImageStoryURL': storyimageURL,
                'StoryDescription':
                    imageDescription == null ? '' : imageDescription
              });
            }
          } //when user sharing a post
          else if (storyIsOnState == false && storyPostImage != null) {
            setState(() {
              pushbuttonState = true;
              if (preferense.getInt('PostIdNumber') == null) {
                postIdNumber = 0;
                postImageId = currentUser.uid.toString() +
                    postIdNumber.toString(); //creating a postId
                preferense.setInt('PostIdNumber',
                    postIdNumber); //saving new postIdnumber in sharede pref
              } else {
                postIdNumber = preferense.getInt('PostIdNumber')!;
                postIdNumber++; //increasing numer by 1
                postImageId = currentUser.uid.toString() +
                    postIdNumber.toString(); //creating a postId
                preferense.setInt('PostIdNumber',
                    postIdNumber); //saving new postIdnumber in sharede pref
              }
            });
            final postRef = await FirebaseStorage.instance
                .ref()
                .child('AllUsersPostImages')
                .child(userName! + '|' + DateTime.now().toString() + '.jpg');

            // Upload the post file using putFile()
            await postRef.putFile(storyPostImage!);

            //download post usrl in storage
            String postimageURL = await postRef.getDownloadURL();

            //save details in firestore
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.uid)
                .update({
              'PostIDs': FieldValue.arrayUnion([
                postImageId
              ]) //saving posts Ids in real time db:firestore to an array
            });

            //making allposts idCollection
            await FirebaseFirestore.instance
                .collection('AllUserPosts')
                .doc('UserPostIds')
                .update({
              'PostIDs': FieldValue.arrayUnion([
                postImageId
              ]) //saving posts Ids in real time db:firestore to an array
            });

            //making user posts details collection
            await FirebaseFirestore.instance
                .collection('AllUserPostsDetails')
                .doc(postImageId)
                .set({
              //saving posts detatils
              'UserID': currentUser.uid,
              'PostURL': postimageURL,
              'PostDescription':
                  imageDescription == null ? '' : imageDescription,
              'LikeCount': 0,
              'CommentCount': 0,
              'CommentedUserName': FieldValue.arrayUnion([]),
              'Comment': FieldValue.arrayUnion([]),
            });
          }
        }
      });
      //after successfull uploading it redirects to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationBarComponent()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        pushbuttonState = false;
      });
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
