// ignore_for_file: unused_local_variable, depend_on_referenced_packages, use_build_context_synchronously, avoid_print, deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_store/pages/home_page.dart';
import 'package:phone_store/pages/login_page.dart';

class AuthenticationActions {
  TextEditingController emailsController;
  TextEditingController passwordController;

  AuthenticationActions(this.emailsController, this.passwordController);

  createAccount(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailsController.text, password: passwordController.text);

      Dialogs.materialDialog(
          color: Colors.white,
          msg: 'Please check your email to verify your account.',
          title: 'Account Created',
          lottieBuilder: Lottie.asset(
            'images/dialog.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              onPressed: () async {
                FirebaseAuth.instance.currentUser!.sendEmailVerification();
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              text: 'Verify your account',
              iconData: Icons.done,
              color: Colors.green,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Dialogs.materialDialog(
          color: Colors.white,
          msg: 'The password provided is too weak.',
          title: 'Warning',
          lottieBuilder: LottieBuilder.asset(
            "images/warning.json",
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'OK',
              iconData: Icons.warning,
              color: Colors.orange,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      } else if (e.code == 'email-already-in-use') {
        Dialogs.materialDialog(
          color: Colors.white,
          msg: 'The account already exists for that email.',
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
    } catch (e) {
      print(e);
    }
  }

  signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailsController.text,
        password: passwordController.text,
      );

      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Dialogs.materialDialog(
          color: Colors.white,
          msg: 'Verify your email first.',
          title: 'Warning',
          lottieBuilder: LottieBuilder.asset(
            "images/warning.json",
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                FirebaseAuth.instance.currentUser!.sendEmailVerification();
                Navigator.of(context).pop();
              },
              text: 'Resend Verification Email',
              iconData: Icons.email,
              color: Colors.orange,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Dialogs.materialDialog(
          color: Colors.white,
          msg: 'No user found for that email.',
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
      } else if (e.code == 'wrong-password') {
        Dialogs.materialDialog(
          color: Colors.white,
          lottieBuilder: LottieBuilder.asset(
            "images/error_dialog.json",
            fit: BoxFit.contain,
          ),
          msg: 'Wrong password provided for that user.',
          title: 'Error',
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
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      print("Starting Google Sign-In...");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("Google Sign-In canceled by user.");
        return;
      }

      print("Google User: ${googleUser.email}");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print("Firebase User: ${userCredential.user?.email}");

      if (userCredential.additionalUserInfo!.isNewUser) {
        print("New user detected.");
        // Show welcome dialog
      } else {
        print("Existing user detected.");
        // Navigate to HomePage
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }
}
