import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:login_project/screens/story_post_screen.dart';
import 'package:login_project/screens/story_showing_screen.dart';
import '../components/post_main_holder_component.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String currentUserID;

  HomeScreen({super.key, required this.currentUserID});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? otherLikeCount, otherCommentCount;

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
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('AllUserPostsDetails')
                          .orderBy('UploadedTime', descending: true)
                          .snapshots(),
                      builder: (context, socialpostSnapshots) {
                        if (socialpostSnapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (socialpostSnapshots.data!.docs.isNotEmpty) {
                          List<Map<String, dynamic>> userPostIDList = [];

                          userPostIDList = socialpostSnapshots.data!.docs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();

                          return ListView.builder(
                              padding: EdgeInsets.only(
                                  top: width * 0.2, bottom: width * 0.05),
                              reverse: false,
                              scrollDirection: Axis.vertical,
                              itemCount: userPostIDList.length,
                              itemBuilder: (context, index) {
                                String senderID =
                                    userPostIDList[index]['UserID'].toString();
                                String postURL =
                                    userPostIDList[index]['PostURL'].toString();
                                String likeCount = userPostIDList[index]
                                        ['LikeCount']
                                    .toString();
                                String commentCount = userPostIDList[index]
                                        ['CommentCount']
                                    .toString();
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(senderID)
                                        .snapshots(),
                                    builder: (context, postDetailsSnapshot) {
                                      if (postDetailsSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // Show a loading indicator while post data is being fetched
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: EdgeInsets.all(16),
                                          child: Container(
                                            width: width,
                                            height: width,
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, top: 8),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 5),
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child:
                                                            FadeShimmer.round(
                                                          size: width * 0.18,
                                                          fadeTheme:
                                                              FadeTheme.dark,
                                                          millisecondsDelay:
                                                              300,
                                                        ),
                                                      ),
                                                    ),
                                                    FadeShimmer(
                                                      height: 8,
                                                      width: 50,
                                                      radius: 4,
                                                      millisecondsDelay: 300,
                                                      fadeTheme: FadeTheme.dark,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        String senderName = postDetailsSnapshot
                                            .data!
                                            .get('ProfileName');
                                        String senderDpUrl = postDetailsSnapshot
                                            .data!
                                            .get('DpURL');

                                        return PhotoHolderComponent(
                                          userName: senderName,
                                          dpURL: senderDpUrl,
                                          postURL: postURL,
                                          likeCount: likeCount.toString(),
                                          commentCount: commentCount.toString(),
                                        );
                                      }
                                    });
                              });
                        } else {
                          return Container(
                            decoration: BoxDecoration(color: Colors.white),
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
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('AllUserStoriesDetails')
                            .orderBy('UploadedTime', descending: true)
                            .snapshots(),
                        builder: (context, otherUserStorySnapshot) {
                          if (otherUserStorySnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (otherUserStorySnapshot
                              .data!.docs.isNotEmpty) {
                            List<String> otherUserStoryIDList = [];

                            for (QueryDocumentSnapshot doc
                                in otherUserStorySnapshot.data!.docs) {
                              String storyID = doc.id;

                              if (widget.currentUserID != storyID) {
                                otherUserStoryIDList.add(storyID);
                              }
                            }

                            if (otherUserStoryIDList.isNotEmpty) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  reverse: true,
                                  itemCount: otherUserStoryIDList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('AllUserStoriesDetails')
                                            .doc(otherUserStoryIDList[index])
                                            .collection('Stories')
                                            .orderBy('UploadedTime',
                                                descending: true)
                                            .snapshots(),
                                        builder: (context,
                                            otherUserStoryDataSnapshot) {
                                          if (otherUserStoryDataSnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          } else if (otherUserStoryDataSnapshot
                                              .data!.docs.isNotEmpty) {
                                            List<Map<String, dynamic>>
                                                otherUserStoryIDList = [];

                                            List<String> otherUserPostURLs = [];

                                            for (QueryDocumentSnapshot doc
                                                in otherUserStoryDataSnapshot
                                                    .data!.docs) {
                                              Map<String, dynamic> userData =
                                                  doc.data()
                                                      as Map<String, dynamic>;
                                              otherUserStoryIDList.add(
                                                  userData); // Append user data to the list
                                            }

                                            for (int i = 0;
                                                i < otherUserStoryIDList.length;
                                                i++) {
                                              otherUserPostURLs.add(
                                                  otherUserStoryIDList[i]
                                                          ['ImageStoryURL']
                                                      .toString());
                                            }
                                            if (otherUserPostURLs.isNotEmpty) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StoryShowingScreen(
                                                              storyURL:
                                                                  otherUserPostURLs,
                                                            )),
                                                  );
                                                },
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
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage: otherUserPostURLs
                                                              .isEmpty
                                                          ? AssetImage(
                                                              'lib/image_assests/icons/user_dp2.png')
                                                          : Image.network(
                                                                  otherUserPostURLs
                                                                      .first)
                                                              .image,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        });
                                  });
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('AllUserStoriesDetails')
                      .snapshots(),
                  builder: (context, currentUserStorySnapshot) {
                    if (currentUserStorySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else if (currentUserStorySnapshot.data!.docs.isNotEmpty) {
                      String? userStoryId;

                      for (QueryDocumentSnapshot doc
                          in currentUserStorySnapshot.data!.docs) {
                        String storyID = doc.id;

                        if (widget.currentUserID == storyID) {
                          userStoryId = storyID;
                        }
                      }

                      if (userStoryId != null) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('AllUserStoriesDetails')
                                .doc(userStoryId)
                                .collection('Stories')
                                .orderBy('UploadedTime', descending: true)
                                .snapshots(),
                            builder: (context, currentUserStorySnapshotData) {
                              if (currentUserStorySnapshotData
                                      .connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (currentUserStorySnapshotData
                                  .data!.docs.isNotEmpty) {
                                List<Map<String, dynamic>>
                                    currentUserStoryIDList = [];

                                List<String> currentUserPostURLs = [];

                                for (QueryDocumentSnapshot doc
                                    in currentUserStorySnapshotData
                                        .data!.docs) {
                                  Map<String, dynamic> userData =
                                      doc.data() as Map<String, dynamic>;
                                  currentUserStoryIDList.add(
                                      userData); // Append user data to the list
                                }

                                for (int i = 0;
                                    i < currentUserStoryIDList.length;
                                    i++) {
                                  currentUserPostURLs.add(
                                      currentUserStoryIDList[i]['ImageStoryURL']
                                          .toString());
                                }

                                if (currentUserPostURLs.isNotEmpty) {
                                  return Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 5, right: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoryShowingScreen(
                                                          storyURL:
                                                              currentUserPostURLs,
                                                        )),
                                              );
                                            },
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
                                                backgroundImage: currentUserPostURLs
                                                        .isEmpty
                                                    ? AssetImage(
                                                        'lib/image_assests/icons/user_dp2.png')
                                                    : Image.network(
                                                            currentUserPostURLs
                                                                .first)
                                                        .image,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: width * 0.13,
                                              right: width * 0.02),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: FloatingActionButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoryPostScreen(
                                                            currentUserId: widget
                                                                .currentUserID,
                                                            storyIsOnStatePasser:
                                                                true,
                                                            storyPostStatePasser:
                                                                0,
                                                          )),
                                                );
                                              },
                                              foregroundColor: Colors.black,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.add_box_outlined,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, right: 5),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(widget
                                                  .currentUserID) // Replace with the  currentUser!.uid
                                              .snapshots(),
                                          builder: (context, userDataSnapshot) {
                                            if (userDataSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              // Handle the loading state if needed
                                              return CircularProgressIndicator(); // Replace with your loading widget
                                            } else {
                                              // Update the state variables with the new data
                                              String userdpURL =
                                                  userDataSnapshot.data!
                                                      .get('DpURL');

                                              return Container(
                                                width: width * 0.18,
                                                height: width * 0.18,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 5,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 100,
                                                      backgroundImage: userdpURL
                                                              .isEmpty
                                                          ? AssetImage(
                                                              'lib/image_assests/icons/user_dp2.png')
                                                          : Image.network(
                                                                  userdpURL)
                                                              .image,
                                                    ),
                                                    FloatingActionButton(
                                                      onPressed: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StoryPostScreen(
                                                                    currentUserId:
                                                                        widget
                                                                            .currentUserID,
                                                                    storyIsOnStatePasser:
                                                                        true,
                                                                    storyPostStatePasser:
                                                                        0,
                                                                  )),
                                                        );
                                                      },
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: Icon(
                                                        Icons
                                                            .add_circle_outline_sharp,
                                                        size: 60,
                                                        color: Colors.white
                                                            .withOpacity(0.4),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  );
                                }
                              } else {
                                return Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, right: 5),
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(widget
                                                .currentUserID) // Replace with the  currentUser!.uid
                                            .snapshots(),
                                        builder: (context, userDataSnapshot) {
                                          if (userDataSnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            // Handle the loading state if needed
                                            return CircularProgressIndicator(); // Replace with your loading widget
                                          } else {
                                            // Update the state variables with the new data
                                            String userdpURL = userDataSnapshot
                                                .data!
                                                .get('DpURL');

                                            return Container(
                                              width: width * 0.18,
                                              height: width * 0.18,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: 5,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 100,
                                                    backgroundImage: userdpURL
                                                            .isEmpty
                                                        ? AssetImage(
                                                            'lib/image_assests/icons/user_dp2.png')
                                                        : Image.network(
                                                                userdpURL)
                                                            .image,
                                                  ),
                                                  FloatingActionButton(
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StoryPostScreen(
                                                                  currentUserId:
                                                                      widget
                                                                          .currentUserID,
                                                                  storyIsOnStatePasser:
                                                                      true,
                                                                  storyPostStatePasser:
                                                                      0,
                                                                )),
                                                      );
                                                    },
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Icon(
                                                      Icons
                                                          .add_circle_outline_sharp,
                                                      size: 60,
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                  ),
                                );
                              }
                            });
                      } else {
                        return Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, right: 5),
                            child: StreamBuilder(
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
                                  } else {
                                    // Update the state variables with the new data
                                    String userdpURL =
                                        userDataSnapshot.data!.get('DpURL');

                                    return Container(
                                      width: width * 0.18,
                                      height: width * 0.18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 100,
                                            backgroundImage: userdpURL.isEmpty
                                                ? AssetImage(
                                                    'lib/image_assests/icons/user_dp2.png')
                                                : Image.network(userdpURL)
                                                    .image,
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoryPostScreen(
                                                          currentUserId: widget
                                                              .currentUserID,
                                                          storyIsOnStatePasser:
                                                              true,
                                                          storyPostStatePasser:
                                                              0,
                                                        )),
                                              );
                                            },
                                            backgroundColor: Colors.transparent,
                                            child: Icon(
                                              Icons.add_circle_outline_sharp,
                                              size: 60,
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        );
                      }
                    } else {
                      return Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 5),
                          child: StreamBuilder(
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
                                } else {
                                  // Update the state variables with the new data
                                  String userdpURL =
                                      userDataSnapshot.data!.get('DpURL');

                                  return Container(
                                    width: width * 0.18,
                                    height: width * 0.18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 5,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 100,
                                          backgroundImage: userdpURL.isEmpty
                                              ? AssetImage(
                                                  'lib/image_assests/icons/user_dp2.png')
                                              : Image.network(userdpURL).image,
                                        ),
                                        FloatingActionButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoryPostScreen(
                                                        currentUserId: widget
                                                            .currentUserID,
                                                        storyIsOnStatePasser:
                                                            true,
                                                        storyPostStatePasser: 0,
                                                      )),
                                            );
                                          },
                                          backgroundColor: Colors.transparent,
                                          child: Icon(
                                            Icons.add_circle_outline_sharp,
                                            size: 60,
                                            color:
                                                Colors.white.withOpacity(0.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
