import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_project/components/story_show_holder.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../components/navigation_bar.dart';

// ignore: must_be_immutable
class StoryShowingScreen extends StatefulWidget {
  List<String> storyURL = [];

  StoryShowingScreen({super.key, required this.storyURL});

  @override
  State<StoryShowingScreen> createState() => _StoryShowingScreenState();
}

class _StoryShowingScreenState extends State<StoryShowingScreen> {
  List<Widget> storyholdersList = [];
  //List<List<int>> list = [];
  int currentStoryState = 0;

  List<double> percentWatched = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.storyURL.length; i++) {
      percentWatched.insert(i, 0);
    }

    storyTimerFunction();
  }

  @override
  void dispose() {
    currentStoryState = 0;

    super.dispose();
  }

  void storyTimerFunction() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (percentWatched[currentStoryState] + 0.01 <= 1) {
          percentWatched[currentStoryState] += 0.01;
        } else {
          percentWatched[currentStoryState] = 1;
          timer.cancel();

          if (currentStoryState < widget.storyURL.length - 1) {
            currentStoryState++;
            storyTimerFunction();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationBarComponent(
                        currentStateChanger: 0,
                      )),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      //final height = constraints.maxHeight;

      for (int i = 0; i < widget.storyURL.length; i++) {
        storyholdersList.insert(
            i, StoryShowHolder(width: width, postURL: widget.storyURL[i]));
      }

      return GestureDetector(
        onTapDown: (details) {
          if (details.globalPosition.dx < width / 2) {
            if (currentStoryState == 0) {
              /* Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigationBarComponent(
                          currentStateChanger: 0,
                        )),
              );*/
              percentWatched[currentStoryState] = 0;
            } else {
              setState(() {
                percentWatched[currentStoryState] = 0;
                currentStoryState--;
                percentWatched[currentStoryState] = 0;
              });
            }
          } else if (details.globalPosition.dx > width / 2) {
            if (currentStoryState < widget.storyURL.length - 1) {
              setState(() {
                percentWatched[currentStoryState] = 1;
                currentStoryState++;
              });
            } else {
              percentWatched[currentStoryState] = 1;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigationBarComponent(
                          currentStateChanger: 0,
                        )),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                storyholdersList[currentStoryState],
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Row(
                    children: [
                      for (int j = 0; j < widget.storyURL.length; j++)
                        Expanded(
                          child: LinearPercentIndicator(
                            alignment: MainAxisAlignment.center,
                            padding: EdgeInsets.only(left: 2, right: 2),
                            lineHeight: 7,
                            percent: percentWatched[j],
                            progressColor: Colors.black,
                            backgroundColor: Colors.grey,
                            barRadius: Radius.circular(10),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
