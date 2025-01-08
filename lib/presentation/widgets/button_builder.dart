import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonBuilder extends StatelessWidget {
  ButtonBuilder({super.key, required this.buttonName, required this.onPressed});
  String buttonName;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: MaterialButton(
        color: const Color.fromARGB(255, 98, 182, 250),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
