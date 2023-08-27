import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'otherUserProf_Screen.dart';

// ignore: must_be_immutable
class SearchScrean extends StatefulWidget {
  String currenUserId;

  SearchScrean({super.key, required this.currenUserId});

  @override
  State<SearchScrean> createState() => _SearchScreanState();
}

class _SearchScreanState extends State<SearchScrean> {
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
      backgroundColor: Colors.white,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: width * 0.07),
              alignment: Alignment.centerLeft,
              width: width,
              height: width * 0.18,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: SizedBox(
                width: width * 0.6,
                height: width * 0.1,
                child: TextField(
                  controller: searchText,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 3,
                          strokeAlign: BorderSide.strokeAlignOutside),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
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
            SizedBox(
              height: width * 0.01,
            ),
            Expanded(
              child: Container(
                width: width,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .snapshots(),
                    builder: (context, userDataSnapshot) {
                      if (userDataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListView.builder(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            scrollDirection: Axis.vertical,
                            itemCount: 4,
                            itemBuilder: (context, index) {
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
                                      borderRadius: BorderRadius.circular(20)),
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
                            });
                      } else if (userDataSnapshot.data!.docs.isNotEmpty) {
                        List<Map<String, dynamic>> otherUsersIDList = [];

                        List<String> otherUserIdList = [];

                        for (QueryDocumentSnapshot doc
                            in userDataSnapshot.data!.docs) {
                          String otherUserID = doc.id;

                          if (otherUserID != widget.currenUserId) {
                            Map<String, dynamic> userData =
                                doc.data() as Map<String, dynamic>;
                            otherUsersIDList
                                .add(userData); // Append user data to the list

                            otherUserIdList.add(otherUserID);
                          }
                        }

                        if (otherUsersIDList.isNotEmpty) {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              scrollDirection: Axis.vertical,
                              itemCount: otherUsersIDList.length,
                              itemBuilder: (context, index) {
                                String userName = otherUsersIDList[index]
                                        ['ProfileName']
                                    .toString();

                                String userDpURL =
                                    otherUsersIDList[index]['DpURL'].toString();

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtherUserProfileScreen(
                                                  currentUser:
                                                      widget.currenUserId,
                                                  otherUserId:
                                                      otherUserIdList[index],
                                                )),
                                      );
                                    },
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
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: userDpURL
                                                        .isEmpty
                                                    ? AssetImage(
                                                        'lib/image_assests/icons/user_dp2.png')
                                                    : Image.network(userDpURL)
                                                        .image,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            userName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: Text('No user IDs available.'),
                          );
                        }
                      } else {
                        return Center(
                          child: Text('No user IDs available.'),
                        );
                      }
                    }),
              ),
            ),
          ],
        );
      })),
    );
  }
}
