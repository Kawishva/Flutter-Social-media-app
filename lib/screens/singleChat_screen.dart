import 'package:flutter/material.dart';

import '../components/navigation_bar.dart';

// ignore: must_be_immutable
class SingleChatScreen extends StatefulWidget {
  String currentUser, otherUser;

  SingleChatScreen(
      {super.key, required this.currentUser, required this.otherUser});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final userMsg = TextEditingController();

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
                decoration: BoxDecoration(color: Colors.amber),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(),
                  width: width,
                  height: userMsg.text.length.toDouble() > 29
                      ? userMsg.text.length.toDouble() * 1.5
                      : width * 0.2,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 30, left: 5, right: 0),
                        child: Wrap(
                          children: [
                            Container(
                              width: width * 0.7, //set width input field holder
                              height:
                                  width * 0.2, //set width input field holder
                              child: TextField(
                                controller: userMsg, //set text holder
                                obscureText: false, //allow hide & visible text
                                keyboardType: TextInputType
                                    .text, //type of text can be input
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFCECECE),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF7D7D7D),
                                        width: 4,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15, right: 5, left: 5),
                        child: IconButton(
                            onPressed: () {
                              print(userMsg.text.length.toDouble());
                            },
                            icon: Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                              size: width * 0.1,
                            )),
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
}
