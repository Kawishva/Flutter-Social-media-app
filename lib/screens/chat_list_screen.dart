import 'package:flutter/material.dart';

class ChatListsScreen extends StatefulWidget {
  const ChatListsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatListsScreenState createState() => _ChatListsScreenState();
}

class _ChatListsScreenState extends State<ChatListsScreen> {
  final searchText = TextEditingController();
  int currentIndex = 0;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> postIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    scrollDirection: Axis.vertical,
                    itemCount: postIds.length,
                    itemBuilder: (BuildContext context, int index) {
                      return null;

                      /* return currentIndex == 0
                          ? PhotoHolderComponent()
                          : PhotoHolderComponent();*/
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenWidth,
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
                          /*Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 5),
                              child: StoryComponent(
                                tapOnStoryFuntion: () {},
                                storyHeight: 50,
                                storyWidth: 50,
                                storyImageAsset:
                                    'lib/image_assests/icons/user_dp2.png',
                              ),
                            ),
                          ),*/
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
                              onPressed: () {
                                setState(() {
                                  currentIndex = 0;
                                });
                              },
                              child: Text(
                                'Chats',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: currentIndex == 0
                                      ? Colors.blue
                                      : Colors.black,
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
                              onPressed: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                              child: Text(
                                'Group Chats',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: currentIndex == 1
                                      ? Colors.blue
                                      : Colors.black,
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
        ),
      ),
    );
  }
}
