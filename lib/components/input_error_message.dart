import 'package:flutter/material.dart';

class InputErrorMessage extends StatelessWidget {
  final String errorMessage;
  final double height;
  final EdgeInsetsGeometry erroMSGPadding;

  const InputErrorMessage(
      {super.key,
      required this.errorMessage,
      required this.height,
      required this.erroMSGPadding});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  void errorMessageFunction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        margin: erroMSGPadding,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/image_assests/icons/flash_messege_icons/wrong_icon.png',
              scale: 15,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              errorMessage,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ));
  }
}
