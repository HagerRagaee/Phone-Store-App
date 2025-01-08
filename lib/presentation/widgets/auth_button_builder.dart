// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButtonBuilder extends StatelessWidget {
  ButtonBuilder({super.key, required this.buttonName, required this.click});
  final String buttonName;
  void Function()? click;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 112, 84, 236),
            Color.fromARGB(255, 203, 137, 247),
          ],
        ),
      ),
      child: TextButton(
        onPressed: click,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }
}
