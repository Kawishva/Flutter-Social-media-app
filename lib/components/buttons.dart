import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double width, height, boarderWidth, fontSize, elevation;

  final Color boarderColor, backgroundColor;
  final FontWeight fontWeight;
  final String buttonName;
  final BorderRadius borderRadius;

  final EdgeInsetsGeometry buttonPadding;

  final void Function()? function;

  const Button(
      {super.key,
      required this.width,
      required this.height,
      required this.boarderWidth,
      required this.buttonPadding,
      required this.elevation,
      required this.fontSize,
      required this.boarderColor,
      required this.backgroundColor,
      required this.fontWeight,
      required this.buttonName,
      required this.borderRadius,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, height),
            elevation: elevation,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide(color: boarderColor, width: boarderWidth)),
            backgroundColor: backgroundColor,
            textStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
        child: Text(buttonName),
      ),
    );
  }
}
