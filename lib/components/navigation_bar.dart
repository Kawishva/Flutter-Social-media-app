import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_project/screens/chat_list_screen.dart';
import 'package:login_project/screens/home_screen.dart';
import 'package:login_project/screens/story_post_screen.dart';
import 'package:login_project/screens/search_screen.dart';
import 'package:page_animation_transition/animations/top_to_bottom_faded.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import '../screens/notification_Screen.dart';
import '../screens/user_profile.dart';

// ignore: must_be_immutable
class NavigationBarComponent extends StatefulWidget {
  int currentStateChanger;
  NavigationBarComponent({super.key, required this.currentStateChanger});

  @override
  State<NavigationBarComponent> createState() => _NavigationBarComponentState();
}

class _NavigationBarComponentState extends State<NavigationBarComponent> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  int currentIndex = 0;

  void initState() {
    super.initState();
    currentIndex = widget.currentStateChanger;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Color for deselected icons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          //final height = constraints.maxHeight;
          return Stack(
            children: [
              FadeIndexedStack(
                beginOpacity: 0.0,
                endOpacity: 1.0,
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
                index: currentIndex,
                children: [
                  HomeScreen(
                    currentUserID: currentUser!.uid,
                  ), //0
                  SearchScrean(
                    currenUserId: currentUser!.uid,
                  ), //1
                  NotificationScreen(
                    currentUserID: currentUser!.uid,
                  ), //2
                  ChatListsScreen(
                    currentUser: currentUser!.uid,
                  ), //3
                  UserProfileScreen(currentUserID: currentUser!.uid), //4
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  height: width * 0.14,
                  decoration: BoxDecoration(
                      color: Colors.black,
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 2;
                          });
                        },
                        child: Icon(
                          currentIndex == 2
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_none,
                          size: width * 0.09,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageAnimationTransition(
                              page: StoryPostScreen(
                                currentUserId: currentUser!.uid,
                                storyIsOnStatePasser: true,
                                storyPostStatePasser: 0,
                              ),
                              pageAnimationType: TopToBottomFadedTransition()));
                        },
                        child: Icon(
                          Icons.image_outlined,
                          size: width * 0.08,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 3;
                          });
                        },
                        child: Icon(
                          currentIndex == 3
                              ? Icons.chat_rounded
                              : Icons.chat_outlined,
                          size: width * 0.08,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.08,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 4;
                          });
                        },
                        child: Icon(
                          currentIndex == 4
                              ? Icons.person_4_sharp
                              : Icons.person_4_outlined,
                          size: width * 0.09,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        })));
  }
}
