import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_project/components/navigation_bar.dart';

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
            // final height = constraints.maxHeight;
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
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('UserRequests')
                                      .doc(widget.currentUser +
                                          widget
                                              .otherUserId) // Replace with the  currentUser!.uid
                                      .snapshots(),
                                  builder: (context, requstSnapshot1) {
                                    if (requstSnapshot1.hasData &&
                                        requstSnapshot1.data!.exists) {
                                      return Text(
                                        'Friends',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber),
                                      );
                                    } else {
                                      return StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('UserRequests')
                                              .doc(widget.otherUserId +
                                                  widget
                                                      .currentUser) // Replace with the  currentUser!.uid
                                              .snapshots(),
                                          builder: (context, requstSnapshot2) {
                                            if (requstSnapshot2.hasData &&
                                                requstSnapshot2.data!.exists) {
                                              return Text(
                                                'Friends',
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
                                                    'Request.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          });
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
                StreamBuilder(
                  // Stream for user's post data changes
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget
                          .otherUserId) // Replace with the currentUser!.uid
                      .snapshots(),
                  builder: (context, postSnapshot) {
                    // Check if the document exists and contains data
                    if (postSnapshot.hasData && postSnapshot.data!.exists) {
                      List<String> postImageIds =
                          List<String>.from(postSnapshot.data!.get('PostIDs'))
                              .reversed
                              .toList();

                      // Return a GridView once the data is available

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
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
                            child: GridView.builder(
                              primary: false,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    3, // Adjust the number of columns as needed
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: postImageIds.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('AllUserPostsDetails')
                                      .doc(postImageIds[index])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Show a loading indicator while post data is being fetched
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.exists) {
                                      String postURL =
                                          snapshot.data!.get('PostURL');

                                      /* int likeCount =
                                            snapshot.data!.get('LikeCount');
                                            
                                        int commentCount =
                                            snapshot.data!.get('CommentCount');*/

                                      return GestureDetector(
                                        onTap: () {
                                          /* Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostShowScreen(
                                                      postId:
                                                          postImageIds[index],
                                                      currentUserId:
                                                          widget.currentUser,
                                                    )),
                                          );*/
                                        },
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              postURL,
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Handle case when post data doesn't exist
                                      return Center(
                                          child: Text(
                                        'Post data not found',
                                        style: TextStyle(color: Colors.black),
                                      ));
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Handle case when document doesn't exist or has no data
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          child: Text('No Post Yet..'),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> requestFunction() async {
    //for current user(request sender)
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.currentUser)
        .update({
      'requestId': FieldValue.arrayUnion([
        widget.currentUser + widget.otherUserId
      ]) //saving story Ids in real time db:firestore to an array
    });

    //for other user(request receaver)
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.otherUserId)
        .update({
      'requestId': FieldValue.arrayUnion([
        widget.currentUser + widget.otherUserId
      ]) //saving story Ids in real time db:firestore to an array
    });

    //save rewuest data
    await FirebaseFirestore.instance
        .collection('UserRequests')
        .doc(widget.currentUser + widget.otherUserId)
        .set({
      'State':
          'Pending..' //saving story Ids in real time db:firestore to an array
    });
  }
}
