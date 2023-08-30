import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessegeHolder extends StatelessWidget {
  String userId, userMsg, time;
  double width;
  CrossAxisAlignment alignmentMessegeHolder;
  MainAxisAlignment alignmentDpAndTime;
  TextAlign alignmentTime;
  bool senderIsCurrentUser;
  Color messegeColor, messegeHolderColor;
  BorderRadius messegeHolderBorderRadius;

  MessegeHolder(
      {super.key,
      required this.userId,
      required this.userMsg,
      required this.width,
      required this.time,
      required this.alignmentMessegeHolder,
      required this.alignmentDpAndTime,
      required this.alignmentTime,
      required this.senderIsCurrentUser,
      required this.messegeColor,
      required this.messegeHolderColor,
      required this.messegeHolderBorderRadius});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .snapshots(),
        builder: (context, userDataSnapshot) {
          if (userDataSnapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while post data is being fetched
            return Column(
              crossAxisAlignment: alignmentMessegeHolder,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: userMsg.length.toDouble() > width / 20
                        ? width * 3 / 4
                        : null,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: messegeHolderColor,
                        borderRadius: messegeHolderBorderRadius),
                    child: FadeShimmer(
                      height: 8,
                      width: 50,
                      radius: 4,
                      millisecondsDelay: 300,
                      fadeTheme: FadeTheme.dark,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 15, right: 5, left: 5),
                  child: senderIsCurrentUser == true
                      ? Row(
                          mainAxisAlignment: alignmentDpAndTime,
                          children: [
                            FadeShimmer(
                              height: 8,
                              width: 50,
                              radius: 4,
                              millisecondsDelay: 300,
                              fadeTheme: FadeTheme.dark,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            FadeShimmer.round(
                              size: width * 0.03,
                              fadeTheme: FadeTheme.dark,
                              millisecondsDelay: 300,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: alignmentDpAndTime,
                          children: [
                            FadeShimmer.round(
                              size: width * 0.03,
                              fadeTheme: FadeTheme.dark,
                              millisecondsDelay: 300,
                            ),
                            SizedBox(
                              width: 5,
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
              ],
            );
          } else {
            String senderDpUrl = userDataSnapshot.data!.get('DpURL');

            return Column(
              crossAxisAlignment: alignmentMessegeHolder,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: userMsg.length.toDouble() > width / 20
                        ? width * 3 / 4
                        : null,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: messegeHolderColor,
                        borderRadius: messegeHolderBorderRadius),
                    child: Text(
                      userMsg,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: messegeColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 15, right: 5, left: 5),
                  child: senderIsCurrentUser == true
                      ? Row(
                          mainAxisAlignment: alignmentDpAndTime,
                          children: [
                            Text(
                              time,
                              textAlign: alignmentTime,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: width * 0.03,
                              backgroundColor: Colors.white,
                              backgroundImage: senderDpUrl.isEmpty
                                  ? AssetImage(
                                      'lib/image_assests/icons/user_dp2.png')
                                  : Image.network(senderDpUrl).image,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: alignmentDpAndTime,
                          children: [
                            CircleAvatar(
                              radius: width * 0.03,
                              backgroundColor: Colors.white,
                              backgroundImage: senderDpUrl.isEmpty
                                  ? AssetImage(
                                      'lib/image_assests/icons/user_dp2.png')
                                  : Image.network(senderDpUrl).image,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              time,
                              textAlign: alignmentTime,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ],
            );
          }
        });
  }
}
