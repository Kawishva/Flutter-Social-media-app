import 'package:flutter/material.dart';

class FlashMessages extends StatelessWidget {
  final String imagePath, text1, text2;
  final Color imageColor, backGroundColor, fontColor;
  final double imageSize;
  final Duration duration;

  const FlashMessages({
    Key? key,
    required this.imagePath,
    required this.text1,
    required this.text2,
    required this.backGroundColor,
    required this.imageColor,
    required this.fontColor,
    required this.imageSize,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  void flashMessageFunction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        content: Container(
          margin: const EdgeInsets.only(
            left: 100,
          ),
          padding: const EdgeInsets.all(5),
          height: 60,
          decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Row(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: ClipRRect(
                  child: Image.asset(
                    imagePath,
                    scale: imageSize,
                    color: imageColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    Flexible(
                      child: Text(
                        text1,
                        style: TextStyle(
                            fontSize: 16,
                            color: fontColor,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        text2,
                        style: TextStyle(
                            fontSize: 14,
                            color: fontColor,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
