import 'package:flutter/material.dart';

//making email & password input field holder that can implement on other .dart files
class EmailPasswordField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final double emailholderwidth, emailholderheight;
  final EdgeInsetsGeometry emailPasswordFieldPadding;

  const EmailPasswordField(
      {super.key,
      required this.emailholderheight,
      required this.emailholderwidth,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.textInputType,
      required this.emailPasswordFieldPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: emailPasswordFieldPadding,
      child: SizedBox(
        width: emailholderwidth, //set width input field holder
        height: emailholderheight, //set width input field holder
        child: TextField(
          controller: controller, //set text holder
          obscureText: obscureText, //allow hide & visible text
          keyboardType: textInputType, //type of text can be input
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFCECECE),
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFF7D7D7D),
                  width: 4,
                  strokeAlign: BorderSide.strokeAlignOutside),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            border: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
