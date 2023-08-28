import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:login_project/screens/singleChat_screen.dart';

// ignore: must_be_immutable
class ChatListsScreen extends StatefulWidget {
  String currentUser;

  ChatListsScreen({super.key, required this.currentUser});

  @override
  // ignore: library_private_types_in_public_api
  _ChatListsScreenState createState() => _ChatListsScreenState();
}

class _ChatListsScreenState extends State<ChatListsScreen> {
  final searchText = TextEditingController();

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
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('UserSingleChatList')
                          .orderBy('LastMessegeTime', descending: true)
                          .snapshots(),
                      builder: (context, docSnapshot) {
                        if (docSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show a loading indicator while post data is being fetched
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              width: width,
                              height: width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 20),
                                    child: Container(
                                      width: width * 0.15,
                                      height: width * 0.15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: FadeShimmer.round(
                                        size: width * 0.18,
                                        fadeTheme: FadeTheme.dark,
                                        millisecondsDelay: 300,
                                      ),
                                    ),
                                  ),
                                  FadeShimmer(
                                    height: width * 0.03,
                                    width: width * 0.15,
                                    radius: 4,
                                    millisecondsDelay: 300,
                                    fadeTheme: FadeTheme.dark,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (docSnapshot.data!.docs.isNotEmpty) {
                          List<String> currentUserChatList = [];

                          for (QueryDocumentSnapshot doc
                              in docSnapshot.data!.docs) {
                            String user1 = doc.get('User1').toString();
                            String user2 = doc.get('User2').toString();

                            if (widget.currentUser == user1 ||
                                widget.currentUser == user2) {
                              currentUserChatList.add(doc.id);
                            }
                          }

                          if (currentUserChatList.isNotEmpty) {
                            return ListView.builder(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                scrollDirection: Axis.vertical,
                                itemCount: currentUserChatList.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('UserSingleChatList')
                                          .doc(currentUserChatList[index])
                                          .snapshots(),
                                      builder: (context, docDetails) {
                                        if (docDetails.connectionState ==
                                            ConnectionState.waiting) {
                                          // Show a loading indicator while post data is being fetched
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              width: width,
                                              height: width * 0.2,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 20),
                                                    child: Container(
                                                      width: width * 0.15,
                                                      height: width * 0.15,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      child: FadeShimmer.round(
                                                        size: width * 0.18,
                                                        fadeTheme:
                                                            FadeTheme.dark,
                                                        millisecondsDelay: 300,
                                                      ),
                                                    ),
                                                  ),
                                                  FadeShimmer(
                                                    height: width * 0.03,
                                                    width: width * 0.15,
                                                    radius: 4,
                                                    millisecondsDelay: 300,
                                                    fadeTheme: FadeTheme.dark,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          String user1ID =
                                              docDetails.data!.get('User1');
                                          String user2ID =
                                              docDetails.data!.get('User2');
                                          String lastMsg = docDetails.data!
                                              .get('LastMessege');
                                          String lastMsgTime = docDetails.data!
                                              .get('LastMessegeTimeShow');

                                          return StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(user1ID ==
                                                          widget.currentUser
                                                      ? user2ID
                                                      : user1ID)
                                                  .snapshots(),
                                              builder:
                                                  (context, requestIDsnapshot) {
                                                if (requestIDsnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  // Show a loading indicator while post data is being fetched
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.black,
                                                    ),
                                                  );
                                                } else {
                                                  String reciverName =
                                                      requestIDsnapshot.data!
                                                          .get('ProfileName');

                                                  String reciverDpUrl =
                                                      requestIDsnapshot.data!
                                                          .get('DpURL');

                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SingleChatScreen(
                                                                    currentUser:
                                                                        widget
                                                                            .currentUser,
                                                                    otherUser: user1ID ==
                                                                            widget.currentUser
                                                                        ? user2ID
                                                                        : user1ID,
                                                                    singleChatId:
                                                                        currentUserChatList[
                                                                            index],
                                                                  )),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 5),
                                                        width: width,
                                                        height: width * 0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          20),
                                                              child: Container(
                                                                width: width *
                                                                    0.15,
                                                                height: width *
                                                                    0.15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  backgroundImage: reciverDpUrl
                                                                          .isEmpty
                                                                      ? AssetImage(
                                                                          'lib/image_assests/icons/user_dp2.png')
                                                                      : Image.network(
                                                                              reciverDpUrl)
                                                                          .image,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              reciverName,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Stack(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: width *
                                                                          0.01,
                                                                      top: 25),
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    width: 175,
                                                                    height: 50,
                                                                    child: Text(
                                                                      lastMsg,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: width *
                                                                          0.36,
                                                                      top: 55),
                                                                  child: Text(
                                                                    lastMsg
                                                                            .toString()
                                                                            .isNotEmpty
                                                                        ? lastMsgTime
                                                                        : '',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              });
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
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: width,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: MediaQuery.of(context).size.width * 0.00099,
                      blurRadius: MediaQuery.of(context).size.width * 0.0099,
                      offset:
                          Offset(-1, MediaQuery.of(context).size.width * 0.008),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: SizedBox(
                              width: 200,
                              height: 33,
                              child: TextField(
                                controller: searchText,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5),
                                        width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                maxLength: 15,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 100),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Chats',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: /*currentIndex == 0
                                      ? Colors.blue
                                      : Colors.black,*/
                                      Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 60),
                            Container(
                              height: 33,
                              width: 2,
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                            ),
                            const SizedBox(width: 60),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Group Chats',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: /*currentIndex == 0
                                      ? Colors.blue
                                      : Colors.black,*/
                                      Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      })),
    );
  }
}
