import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearchScrean extends StatefulWidget {
  const SearchScrean({super.key});

  @override
  State<SearchScrean> createState() => _SearchScreanState();
}

class _SearchScreanState extends State<SearchScrean> {
  final searchText = TextEditingController();
  List<String> userIdsList = [];

  User? currentUser = FirebaseAuth.instance.currentUser;

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
                  color: Colors.black,
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
                          color: Colors.blue,
                          width: 3,
                          strokeAlign: BorderSide.strokeAlignOutside),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    border: InputBorder.none,
                    counterText: '',
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 25,
                      color: Colors.blue,
                    ),
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  maxLength: 15,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
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
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('AllUserIDs')
                        .doc('UserIDs')
                        .snapshots(),
                    builder: (context, userIDsnapshot) {
                      userIdsList.clear();
                      if (userIDsnapshot.connectionState ==
                          ConnectionState.waiting) {
                        // Show a loading indicator while data is being fetched
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      } else {
                        List<String> userIdsList = List<String>.from(
                          userIDsnapshot.data!.get('UserIDs') ?? [],
                        ).reversed.toList();

                        if (userIdsList.isNotEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 0),
                            scrollDirection: Axis.vertical,
                            itemCount: userIdsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(userIdsList[index])
                                    .snapshots(),
                                builder: (context, otherUserSnapshot) {
                                  if (otherUserSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ListTile(
                                      title: Text('Loading...'),
                                    );
                                  } else {
                                    String userName = otherUserSnapshot.data!
                                        .get('ProfileName');

                                    String userDpUrl =
                                        otherUserSnapshot.data!.get('DpURL');

                                    return ListTile(
                                      title: Text(userName),
                                      subtitle: Text(userIdsList[index]),
                                      // Add more widgets as needed
                                    );
                                  }
                                },
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text('No user IDs available.'),
                          );
                        }
                      }
                    },
                  )),
            ),
          ],
        );
      })),
    );
  }
}
