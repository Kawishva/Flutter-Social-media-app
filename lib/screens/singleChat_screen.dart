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
                decoration: BoxDecoration(color: Colors.amber),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(),
                  width: width,
                  height: userMsg.text.length.toDouble() <= 30
                      ? 70
                      : userMsg.text.length.toDouble() > 30 &&
                              userMsg.text.length.toDouble() <= 60
                          ? 85
                          : userMsg.text.length.toDouble() > 60 &&
                                  userMsg.text.length.toDouble() < 90
                              ? 100
                              : userMsg.text.length.toDouble() > 90 &&
                                      userMsg.text.length.toDouble() <= 120
                                  ? 115
                                  : 135,
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
                              onPressed: () {
                                print(userMsg.text.length.toDouble());
                              },
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
                                              : 125, //set width input field holder
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
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF7D7D7D),
                                        width: 4,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
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
                                print(userMsg.text.length.toDouble());
                              },
                              icon: Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                                size: width * 0.1,
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
}
