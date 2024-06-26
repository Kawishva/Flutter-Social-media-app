import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_project/components/navigation_bar.dart';

import '../components/flash_messages.dart';

// ignore: must_be_immutable
class OtherUserProfileScreen extends StatefulWidget {
  String currentUser, otherUserId;

  OtherUserProfileScreen(
      {super.key, required this.currentUser, required this.otherUserId});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreen();
}

class _OtherUserProfileScreen extends State<OtherUserProfileScreen> {
  List<String> postImageIds = []; // List of post URLs from Firebase

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationBarComponent(
                    currentStateChanger: 1,
                  )),
        ); // This will navigate back to the previous screen

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.02, top: width * 0.02),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('UserRequests')
                                      .snapshots(),
                                  builder: (context, userRequsetSnapshot) {
                                    if (userRequsetSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (userRequsetSnapshot
                                        .data!.docs.isNotEmpty) {
                                      Map<String, dynamic>? requestID;

                                      for (QueryDocumentSnapshot doc
                                          in userRequsetSnapshot.data!.docs) {
                                        if (widget.currentUser +
                                                    widget.otherUserId ==
                                                doc.id ||
                                            widget.otherUserId +
                                                    widget.currentUser ==
                                                doc.id) {
                                          Map<String, dynamic> userData = doc
                                              .data() as Map<String, dynamic>;
                                          requestID = userData;
                                        }
                                      }

                                      String sender = requestID != null
                                          ? requestID['Sender'].toString()
                                          : '';

                                      if (requestID != null) {
                                        return Text(
                                          widget.currentUser == sender
                                              ? 'Request\nSent'
                                              : 'Request\nRecieved',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber),
                                        );
                                      } else {
                                        return Container(
                                          alignment: Alignment.center,
                                          width: 70,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              requestFunction();
                                            },
                                            child: Text(
                                              'Request',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      return Container(
                                        alignment: Alignment.center,
                                        width: 70,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            requestFunction();
                                          },
                                          child: Text(
                                            'Request',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  })),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              Text('Followers'),
                              Text('Posts'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.2,
                    ),
                    StreamBuilder(
                        // Stream for user data changes
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget
                                .otherUserId) // Replace with the  currentUser!.uid
                            .snapshots(),
                        builder: (context, userDataSnapshot) {
                          if (userDataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Handle the loading state if needed
                            return CircularProgressIndicator(); // Replace with your loading widget
                          }

                          // Update the state variables with the new data
                          String userdpURL =
                              userDataSnapshot.data!.get('DpURL');
                          String userName =
                              userDataSnapshot.data!.get('ProfileName');
                          String userDescription =
                              userDataSnapshot.data!.get('Description');

                          return Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: width * 0.1),
                                child: Container(
                                  width: width * 0.3,
                                  height: width * 0.3,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: userdpURL.isEmpty
                                        ? AssetImage(
                                            'lib/image_assests/icons/user_dp2.png')
                                        : Image.network(userdpURL).image,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: width * 0.1),
                                    child: Text(
                                      userName.isEmpty ? '' : userName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 1, right: 0),
                                    child: Container(
                                      width: width * 0.25,
                                      height: width * 0.25,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent),
                                      child: Text(
                                        userDescription.isEmpty
                                            ? ''
                                            : userDescription,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: Offset(0, -4),
                              blurStyle: BlurStyle.normal),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        // Stream for user's post data changes
                        stream: FirebaseFirestore.instance
                            .collection('AllUserPostsDetails')
                            .orderBy('UploadedTime', descending: true)
                            .snapshots(),
                        builder: (context, postSnapshot) {
                          if (postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (postSnapshot.data!.docs.isNotEmpty) {
                            List<Map<String, dynamic>> userPostList = [];

                            for (QueryDocumentSnapshot doc
                                in postSnapshot.data!.docs) {
                              String userID = doc.get('UserID').toString();

                              if (widget.otherUserId == userID) {
                                Map<String, dynamic> userData =
                                    doc.data() as Map<String, dynamic>;
                                userPostList.add(
                                    userData); // Append user data to the list
                              }
                            }

                            return GridView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3, // Adjust the number of columns as needed
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                ),
                                itemCount: userPostList.length,
                                itemBuilder: (context, index) {
                                  String postURL =
                                      userPostList[index]['PostURL'].toString();

                                  return Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        postURL,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> requestFunction() async {
    DateTime currentStamp = DateTime.now();

    String formattedTime = DateFormat('h:mm:ss a').format(currentStamp);
    // String time = DateFormat('h:mm a').format(currentStamp);
    String date = DateFormat.yMd().format(currentStamp);

    try {
      //save rewuest data
      await FirebaseFirestore.instance
          .collection('UserRequests')
          .doc(widget.currentUser + widget.otherUserId)
          .set({
        'Sender': widget.currentUser,
        'Reciever': widget.otherUserId,
        'SendTime': '$date||$formattedTime',
        'State': 'Pending',
        //saving story Ids in real time db:firestore to an array
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
