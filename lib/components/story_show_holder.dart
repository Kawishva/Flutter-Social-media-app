import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoryShowHolder extends StatelessWidget {
  double width;
  String postURL;

  StoryShowHolder({super.key, required this.width, required this.postURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: width * 0.23, right: width * 0.015, left: width * 0.015),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(postURL)),
    );
  }
}
