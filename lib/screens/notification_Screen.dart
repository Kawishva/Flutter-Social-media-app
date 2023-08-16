import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  String currentUser;

  NotificationScreen({super.key, required this.currentUser});

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

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.currentUser)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                List<String> requsetList =
                    List<String>.from(snapshot.data!.get('requestId'))
                        .reversed
                        .toList();

                if (requsetList.isNotEmpty) {
                  return Container(
                    width: width,
                    height: height,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      scrollDirection: Axis.vertical,
                      itemCount: requsetList.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('UserRequests')
                                .doc(requsetList[index])
                                .snapshots(),
                            builder: (context, requestIDsListnapshot) {
                              if (requestIDsListnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Show a loading indicator while post data is being fetched
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                String senderId =
                                    requestIDsListnapshot.data!.get('Sender');
                                String recieverId =
                                    requestIDsListnapshot.data!.get('Reciever');
                                String state =
                                    requestIDsListnapshot.data!.get('State');

                                if (senderId == widget.currentUser) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(recieverId)
                                          .snapshots(),
                                      builder: (context, requestIDsnapshot) {
                                        if (requestIDsnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Show a loading indicator while post data is being fetched
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          );
                                        } else {
                                          String reciverName = requestIDsnapshot
                                              .data!
                                              .get('ProfileName');

                                          String reciverDpUrl =
                                              requestIDsnapshot.data!
                                                  .get('DpURL');

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
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.black)),
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
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
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
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.3,
                                                  ),
                                                  Text(
                                                    state,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                } else {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(senderId)
                                          .snapshots(),
                                      builder: (context, requestIDsnapshot) {
                                        if (requestIDsnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Show a loading indicator while post data is being fetched
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          );
                                        } else {
                                          String reciverName = requestIDsnapshot
                                              .data!
                                              .get('ProfileName');

                                          String reciverDpUrl =
                                              requestIDsnapshot.data!
                                                  .get('DpURL');

                                          if (requestIDsnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return ListTile(
                                              title: Text('Loading...'),
                                            );
                                          } else {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                width: width,
                                                height: width * 0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.black)),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
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
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.15,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 70,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {},
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: 70,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {},
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
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      });
                                }
                              }
                            });
                      },
                    ),
                  );
                } else {
                  return Text('No Notification');
                }
              } else {
                return Text('No Notification');
              }
            });
      })),
    );
  }
}
