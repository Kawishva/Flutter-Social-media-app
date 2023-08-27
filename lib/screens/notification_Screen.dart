import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/flash_messages.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  String currentUserID;
  NotificationScreen({super.key, required this.currentUserID});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('UserRequests')
                .orderBy('SendTime', descending: true)
                .snapshots(),
            builder: (context, userRequsetSnapshot) {
              if (userRequsetSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Container();
              } else if (userRequsetSnapshot.data!.docs.isNotEmpty) {
                List<String> requestIDList = [];

                String? senderID, recieverID;

                for (QueryDocumentSnapshot doc
                    in userRequsetSnapshot.data!.docs) {
                  senderID = doc.get('Sender').toString();
                  recieverID = doc.get('Reciever').toString();

                  if (widget.currentUserID == senderID ||
                      widget.currentUserID == recieverID) {
                    requestIDList.add(doc.id);
                  }
                }

                if (requestIDList.isNotEmpty) {
                  return ListView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      scrollDirection: Axis.vertical,
                      itemCount: requestIDList.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(widget.currentUserID == senderID
                                    ? recieverID
                                    : senderID)
                                .snapshots(),
                            builder: (context, otherUserSnapshot) {
                              if (otherUserSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(16),
                                  child: Container(
                                    width: width,
                                    height: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 20),
                                          child: Container(
                                            width: width * 0.18,
                                            height: width * 0.18,
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
                                          height: 8,
                                          width: 150,
                                          radius: 4,
                                          millisecondsDelay: 300,
                                          fadeTheme: FadeTheme.dark,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                String reciverName =
                                    otherUserSnapshot.data!.get('ProfileName');

                                String reciverDpUrl =
                                    otherUserSnapshot.data!.get('DpURL');

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    width: width,
                                    height: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: Colors.black)),
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
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: reciverDpUrl
                                                      .isEmpty
                                                  ? AssetImage(
                                                      'lib/image_assests/icons/user_dp2.png')
                                                  : Image.network(reciverDpUrl)
                                                      .image,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          reciverName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: width * 0.3,
                                        ),
                                        widget.currentUserID == senderID
                                            ? Text(
                                                'Requset Sent',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 70,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black,
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        userAcceptFunction(
                                                            requestIDList[
                                                                index],
                                                            senderID!,
                                                            recieverID!);
                                                        //accept funtion
                                                      },
                                                      child: Text(
                                                        'Accept',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 70,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black,
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        //accept funtion
                                                        userRejectFunction(
                                                            requestIDList[
                                                                index],
                                                            senderID!,
                                                            recieverID!);
                                                      },
                                                      child: Text(
                                                        'Reject',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            });
                      });
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            });
      })),
    );
  }

  Future<void> userAcceptFunction(
      String requestId, String user1, String user2) async {
    DateTime currentStamp = DateTime.now();

    String formattedTime = DateFormat.Hm().format(currentStamp);
    String formattedDate = DateFormat.yMd().format(currentStamp);

    try {
      await FirebaseFirestore.instance
          .collection('UserSingleChatList')
          .doc(requestId)
          .set({
        'Created': '$formattedTime||$formattedDate',
        'LastMessegeTime': '$formattedDate||$formattedDate',
        'LastMessegeTimeShow': '',
        'LastMessege': '',
        'User1': user1,
        'User2': user2
      });

      await FirebaseFirestore.instance
          .collection('UserRequests')
          .doc(requestId)
          .update({'State': 'Accepted'});
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

  Future<void> userRejectFunction(
      String requestId, String user1, String user2) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserRequests')
          .doc(requestId)
          .update({'State': 'Rejected'});
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
