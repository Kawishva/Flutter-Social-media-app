import 'package:flutter/material.dart';

class ShowDialogRequest extends StatelessWidget {
  final String button1, button2, imageAsset;
  final void Function()? button1Function, button2Function;

  const ShowDialogRequest(
      {super.key,
      required this.button1,
      required this.button2,
      required this.imageAsset,
      required this.button1Function,
      required this.button2Function});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  void imagePickerFunction(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageAsset,
                  scale: 12,
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: Colors.black)),
                  child: TextButton(
                    onPressed: button1Function,
                    child: Text(
                      button1,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: Colors.black)),
                  child: TextButton(
                    onPressed: button2Function,
                    child: Text(
                      button2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
