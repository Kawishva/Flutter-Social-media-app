import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:login_project/screens/postShow_Screen.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatefulWidget {
  String currentUserID;
  UserProfileScreen({super.key, required this.currentUserID});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 225, 225)
                        .withOpacity(0.5)),
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

                      List<String> userPostIDList = [];

                      for (QueryDocumentSnapshot doc
                          in postSnapshot.data!.docs) {
                        String userID = doc.get('UserID').toString();

                        String postID = doc.id;

                        if (widget.currentUserID == userID) {
                          Map<String, dynamic> userData =
                              doc.data() as Map<String, dynamic>;
                          userPostList
                              .add(userData); // Append user data to the list

                          userPostIDList.add(postID);
                        }
                      }

                      return GridView.builder(
                          primary: false,
                          padding: EdgeInsets.only(top: width * 0.28),
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

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostShowScreen(
                                            postId: userPostIDList[index],
                                          )),
                                );
                              },
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.white),
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
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              StreamBuilder(
                  // Stream for user data changes
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget
                          .currentUserID) // Replace with the  currentUser!.uid
                      .snapshots(),
                  builder: (context, userDataSnapshot) {
                    if (userDataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      // Handle the loading state if needed
                      return CircularProgressIndicator(); // Replace with your loading widget
                    }

                    // Update the state variables with the new data
                    String userdpURL = userDataSnapshot.data!.get('DpURL');
                    String userName = userDataSnapshot.data!.get('ProfileName');
                    String userDescription =
                        userDataSnapshot.data!.get('Description');

                    return Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 2, right: 2),
                          child: Container(
                            width: width * 0.989,
                            height: width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Container(
                                          width: width * 0.3 / 2,
                                          height: width * 0.12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            /*border: Border.all(
                                                width: 2,
                                                color: Colors.black,
                                                strokeAlign:
                                                    BorderSide.strokeAlignOutside)*/
                                          ),
                                          child: TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Edit Profile',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 20,
                                          right: width * 0.01,
                                          left: width * 0.62),
                                      child: Container(
                                        width: width * 0.17,
                                        height: width * 0.17,
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
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: width * 0.2, left: width * 0.7),
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.55, top: width * 0.02),
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: userName.isEmpty
                                          ? 0
                                          : userName.length.toDouble() * 10,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: userName == ''
                                              ? Colors.transparent
                                              : Colors.white.withOpacity(0.5)),
                                      child: Text(
                                        userName.isEmpty ? '' : userName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      )),
                                ),
                              ],
                            ),
                          )),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }
}
