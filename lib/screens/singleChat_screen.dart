import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../components/flash_messages.dart';
import '../components/messegeHolder.dart';
import '../components/navigation_bar.dart';

// ignore: must_be_immutable
class SingleChatScreen extends StatefulWidget {
  String currentUser, otherUser, singleChatId;

  SingleChatScreen(
      {super.key,
      required this.currentUser,
      required this.otherUser,
      required this.singleChatId});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final userMsg = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userMsg.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return WillPopScope(
          onWillPop: () async {
            // Handle the back button press here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 3,
                      )),
            ); // This will navigate back to the previous screen

            return false;
          },
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(color: Colors.white),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('UserSingleChatList')
                        .doc(widget.singleChatId)
                        .collection('ChatData')
                        .snapshots(),
                    builder: (context, msgSnapshots) {
                      if (msgSnapshots.connectionState ==
                          ConnectionState.waiting) {
                        return Container();
                      } else if (msgSnapshots.data!.docs.isNotEmpty) {
                        List<Map<String, dynamic>> currentUserChatDataList = [];

                        List<String> chatDocIdList = [];

                        for (QueryDocumentSnapshot doc
                            in msgSnapshots.data!.docs) {
                          chatDocIdList.add(doc.id);
                        }

                        // Process the data
                        currentUserChatDataList = msgSnapshots.data!.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList()
                            .reversed
                            .toList();

                        return ListView.builder(
                            padding:
                                EdgeInsets.only(top: 0, bottom: width * 0.15),
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            itemCount: currentUserChatDataList.length,
                            itemBuilder: (context, index) {
                              String senderId = currentUserChatDataList[index]
                                      ['Sender']
                                  .toString();
                              /*  String reciverId = currentUserChatDataList[index]
                                      ['Reciver']
                                  .toString();*/
                              String msg = currentUserChatDataList[index]
                                      ['Messege']
                                  .toString();
                              String time = currentUserChatDataList[index]
                                      ['Time']
                                  .toString();

                              return Slidable(
                                endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        // An action can be bigger than the others.

                                        onPressed: (context) {
                                          messegeDeleteFunction(
                                              chatDocIdList[index]);
                                        },
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete_forever_outlined,
                                      ),
                                    ]),
                                child: MessegeHolder(
                                  userId: widget.currentUser == senderId
                                      ? senderId
                                      : senderId,
                                  userMsg: msg,
                                  width: width,
                                  time: time,
                                  alignmentMessegeHolder:
                                      widget.currentUser == senderId
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  alignmentDpAndTime:
                                      widget.currentUser == senderId
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  alignmentTime: widget.currentUser == senderId
                                      ? TextAlign.end
                                      : TextAlign.start,
                                  messegeColor: widget.currentUser == senderId
                                      ? Colors.white
                                      : Colors.black,
                                  messegeHolderColor:
                                      widget.currentUser == senderId
                                          ? Colors.black
                                          : Colors.grey.withOpacity(0.6),
                                  messegeHolderBorderRadius:
                                      widget.currentUser == senderId
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                  senderIsCurrentUser:
                                      widget.currentUser == senderId
                                          ? true
                                          : false,
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(),
                  width: width,
                  height: userMsg.text.length.toDouble() <= 30
                      ? 60
                      : userMsg.text.length.toDouble() > 30 &&
                              userMsg.text.length.toDouble() <= 60
                          ? 75
                          : userMsg.text.length.toDouble() > 60 &&
                                  userMsg.text.length.toDouble() < 90
                              ? 90
                              : userMsg.text.length.toDouble() > 90 &&
                                      userMsg.text.length.toDouble() <= 120
                                  ? 105
                                  : 120,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(40))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 15, right: 5, left: 0),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_box_outlined,
                                color: Colors.white,
                                size: width * 0.095,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: width * 0, right: 0),
                        child: Wrap(
                          children: [
                            SizedBox(
                              width: width * 0.7,
                              //set width input field holder
                              height: userMsg.text.length.toDouble() <= 30
                                  ? 60
                                  : userMsg.text.length.toDouble() > 30 &&
                                          userMsg.text.length.toDouble() <= 60
                                      ? 75
                                      : userMsg.text.length.toDouble() > 60 &&
                                              userMsg.text.length.toDouble() <=
                                                  90
                                          ? 90
                                          : userMsg.text.length.toDouble() >
                                                      90 &&
                                                  userMsg.text.length
                                                          .toDouble() <=
                                                      120
                                              ? 105
                                              : 115, //set width input field holder
                              child: TextField(
                                controller: userMsg, //set text holder
                                obscureText: false, //allow hide & visible text
                                keyboardType: TextInputType
                                    .text, //type of text can be input
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                maxLines: null,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 15, right: 5, left: 5),
                          child: IconButton(
                              onPressed: () {
                                sendMessegeFunction();
                              },
                              icon: Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                                size: width * 0.090,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      })),
    );
  }

  Future<void> sendMessegeFunction() async {
    DateTime currentStamp = DateTime.now();

    String formattedTime = DateFormat('HH:mm:ss').format(currentStamp);
    String time = DateFormat('h:mm a').format(currentStamp);
    String year = DateFormat.y().format(currentStamp);
    String month = DateFormat.M().format(currentStamp);
    String date = DateFormat.d().format(currentStamp);

    if (userMsg.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('UserSingleChatList')
            .doc(widget.singleChatId)
            .collection('ChatData')
            .doc('$date.$month.$year||$formattedTime')
            .set({
          'SentTime': formattedTime,
          'Time': time,
          'SentDate': '$date/$month/$year',
          'Sender': widget.currentUser,
          'Reciver': widget.otherUser,
          'Messege': userMsg.text
        });

        await FirebaseFirestore.instance
            .collection('UserSingleChatList')
            .doc(widget.singleChatId)
            .update({
          'LastMessegeTime': '$date/$month/$year||$formattedTime',
          'LastMessegeTimeShow': time,
          'LastMessege': userMsg.text,
        });

        userMsg.clear();
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

  Future<void> messegeDeleteFunction(String msgDocId) async {
    try {
      FirebaseFirestore currentPostSnapshot = await FirebaseFirestore.instance;

      //delete post from all user post collection
      currentPostSnapshot
          .collection('UserSingleChatList')
          .doc(widget.singleChatId)
          .collection('ChatData')
          .doc(msgDocId)
          .delete();
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
