import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../components/post_main_holder_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? otherLikeCount, otherCommentCount;

  User? currentUser = FirebaseAuth.instance.currentUser;

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
      backgroundColor: Colors.white, //use for toggle night mode
      body: SafeArea(
        top: true,
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('AllUserPosts')
                          .doc('UserPostIds')
                          .snapshots(),
                      builder: (context, socialpostSnapshots) {
                        // Check if the document exists and contains data

                        if (socialpostSnapshots.hasData &&
                            socialpostSnapshots.data!.exists) {
                          /* List<String> postImageIdsList = List<String>.from(
                              socialpostSnapshots.data!.get('PostIDs'));
                          postImageIdsList
                              .shuffle(); */
                          List<String> postImageIdsList = List<String>.from(
                                  socialpostSnapshots.data!.get('PostIDs'))
                              .reversed
                              .toList();
                          if (postImageIdsList.isNotEmpty) {
                            return Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: width * 0.2, bottom: width * 0.05),
                                  scrollDirection: Axis.vertical,
                                  itemCount: postImageIdsList.length,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('AllUserPostsDetails')
                                          .doc(postImageIdsList[index])
                                          .snapshots(),
                                      builder: (context, postIDsnapshot) {
                                        if (postIDsnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Show a loading indicator while post data is being fetched
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          );
                                        } else {
                                          String otherUserId = postIDsnapshot
                                              .data!
                                              .get('UserID');
                                          String othrUserPostUrl =
                                              postIDsnapshot.data!
                                                  .get('PostURL');
                                          int likeCount = postIDsnapshot.data!
                                              .get('LikeCount');
                                          int commentCount = postIDsnapshot
                                              .data!
                                              .get('CommentCount');

                                          return StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(otherUserId)
                                                  .snapshots(),
                                              builder: (context,
                                                  otherUserDatasnapshot) {
                                                if (otherUserDatasnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(); // Show nothing while user data is being fetched
                                                } else {
                                                  String otherUserName =
                                                      otherUserDatasnapshot
                                                          .data!
                                                          .get('ProfileName');
                                                  String otherUserDpUrl =
                                                      otherUserDatasnapshot
                                                          .data!
                                                          .get('DpURL');
                                                  return PhotoHolderComponent(
                                                    userName: otherUserName,
                                                    dpURL: otherUserDpUrl,
                                                    postURL: othrUserPostUrl,
                                                    likeCount:
                                                        likeCount.toString(),
                                                    commentCount:
                                                        commentCount.toString(),
                                                  );
                                                }
                                              });
                                        }
                                      },
                                    );
                                  },
                                ));
                          } else {
                            return Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text('No Post has been posted yet..'),
                              ),
                            );
                          }
                        } else if (socialpostSnapshots.hasError) {
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text('No Post has been posted yet..'),
                            ),
                          );
                        } else {
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text('No Post has been posted yet..'),
                            ),
                          );
                        }
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.018),
                  child: Container(
                    padding: EdgeInsets.only(right: width * 0.178),
                    width: width,
                    height: 63,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: width * 0.18,
                                  height: width * 0.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'lib/image_assests/icons/user_dp2.png',
                                    fit: BoxFit.contain,
                                  )),
                            ),
                          );
                        }),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUser!.uid)
                      .snapshots(),
                  builder: (context, userDataSnapshot) {
                    if (userDataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      // Handle the loading state if needed
                      return CircularProgressIndicator(); // Replace with your loading widget
                    }

                    String userdpURL = userDataSnapshot.data!.get('DpURL');
                    return Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, right: 5),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: width * 0.18,
                            height: width * 0.18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 5,
                                color: Colors.black,
                              ),
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
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void pressedOnStoryFunction() {}
}
