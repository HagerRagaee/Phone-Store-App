// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:phone_store/Data/authentication_data.dart';
import 'package:phone_store/pages/Sign_up.dart';
import 'package:phone_store/pages/login_page.dart';
import 'package:phone_store/structure/auth_button_builder.dart';
import 'package:phone_store/structure/textField_builder.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthenticationActions authenticationActions;

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void initState() {
    authenticationActions =
        AuthenticationActions(emailController, passwordController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Image.asset(
              "images/quiz2.png",
              height: 35,
            )
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Enter your details below",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldBuilder(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "This field is required!";
                    }
                    // Regular expression to validate email format
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(val)) {
                      return "Please enter a valid email address!";
                    }
                    return null;
                  },
                  controller: emailController,
                  fieldName: "Email",
                ),
                SizedBox(height: 20),
                TextFieldBuilder(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "field is required!";
                    }

                    return null;
                  },
                  controller: passwordController,
                  fieldName: "Password",
                ),
                SizedBox(height: 20),
                ButtonBuilder(
                    buttonName: "Sign in",
                    click: () {
                      if (formState.currentState!.validate()) {
                        authenticationActions.signIn(context);
                      }
                    }),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        TextButton(
          child: Text(
            "Forget your password? ",
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            if (emailController.text.length > 0) {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: emailController.text);
              Dialogs.materialDialog(
                  color: Colors.white,
                  msg: 'Please check your email to reset your password.',
                  title: 'Reset password',
                  lottieBuilder: Lottie.asset(
                    'images/dialog.json',
                    fit: BoxFit.contain,
                  ),
                  context: context,
                  actions: [
                    IconsButton(
                      onPressed: () {
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      text: 'Reset your password',
                      iconData: Icons.done,
                      color: Colors.green,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ]);
            } else {
              Dialogs.materialDialog(
                color: Colors.white,
                msg: 'Please enter your email first.',
                title: 'Error',
                lottieBuilder: LottieBuilder.asset(
                  "images/error_dialog.json",
                  fit: BoxFit.contain,
                ),
                context: context,
                actions: [
                  IconsButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'OK',
                    iconData: Icons.error,
                    color: Colors.red,
                    textStyle: const TextStyle(color: Colors.white),
                    iconColor: Colors.white,
                  ),
                ],
              );
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don`t have an account?",
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            )
          ],
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Text(
                  "Or Sign in with",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // SigninOptions(
        //   actions: authenticationActions,
        // )
      ],
    );
  }
}
