import 'package:flutter/material.dart';

class ButtonBuilder extends StatelessWidget {
  final String buttonName;
  final void Function()? onPressed;

  const ButtonBuilder({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = screenWidth * 0.2; // 40% of the screen width
    final buttonHeight = screenHeight * 0.07; // 7% of the screen height
    final fontSize = screenWidth * 0.016; // 4.5% of the screen width

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: MaterialButton(
        color: const Color.fromARGB(255, 98, 182, 250),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Add rounded corners
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
