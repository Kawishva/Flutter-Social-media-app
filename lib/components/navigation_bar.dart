import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_project/screens/chat_list_screen.dart';
import 'package:login_project/screens/home_screen.dart';
import 'package:login_project/screens/story_post_screen.dart';

import 'package:login_project/screens/search_screen.dart';
import '../screens/user_profile.dart';

class NavigationBarComponent extends StatefulWidget {
  const NavigationBarComponent({super.key});

  @override
  State<NavigationBarComponent> createState() => _NavigationBarComponentState();
}

class _NavigationBarComponentState extends State<NavigationBarComponent> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  int currentIndex = 0;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Color for deselected icons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          //final height = constraints.maxHeight;
          return Stack(
            children: [
              IndexedStack(
                index: currentIndex,
                children: [
                  HomeScreen(),
                  SearchScrean(),
                  ChatListsScreen(),
                  UserProfileScreen(currentUser: currentUser!.uid),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 0, top: width * 1.8),
                  width: width,
                  height: width * 0.14,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        child: Icon(
                          currentIndex == 0
                              ? Icons.home_sharp
                              : Icons.home_outlined,
                          size: width * 0.09,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                          });
                        },
                        child: Icon(
                          currentIndex == 1 ? Icons.search : Icons.search_off,
                          size: width * 0.09,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StoryPostScreen()),
                          );
                        },
                        child: Icon(
                          Icons.image_outlined,
                          size: width * 0.09,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 2;
                          });
                        },
                        child: Icon(
                          currentIndex == 2
                              ? Icons.chat_rounded
                              : Icons.chat_outlined,
                          size: width * 0.09,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 3;
                          });
                        },
                        child: Icon(
                          currentIndex == 3
                              ? Icons.person_4_sharp
                              : Icons.person_4_outlined,
                          size: width * 0.09,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        })));
  }
}
