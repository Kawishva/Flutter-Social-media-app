import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String imagepath;
  final double size, padding;

  const SquareTitle(
      {super.key,
      required this.imagepath,
      required this.size,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC3C1C1), width: 0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: MediaQuery.of(context).size.width *
                0.0005, // Adjust the spread radius dynamically
            blurRadius: MediaQuery.of(context).size.width *
                0.01, // Adjust the blur radius dynamically
            offset: Offset(
                0,
                MediaQuery.of(context).size.width *
                    0.01), // Adjust the offset dynamically
          ),
        ],
      ),
      child: Image.asset(
        imagepath,
        scale: size,
      ),
    );
  }
}
