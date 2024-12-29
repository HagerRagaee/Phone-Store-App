import 'package:flutter/material.dart';
import 'package:phone_store/templetes/sign_in_form.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 85, 50, 243),
                  Color.fromARGB(255, 174, 161, 236),
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Trivio",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(235, 47, 47, 48),
                      blurRadius: 20,
                      spreadRadius: 7,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: LoginForm()),
          ),
        ],
      ),
    );
  }
}
