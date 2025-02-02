import "dart:io";
import "dart:math";

import "package:chit_chat/Api/api.dart";
import "package:chit_chat/helper/dialogue.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:google_sign_in/google_sign_in.dart";
import 'dart:developer';

import "../home_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isanimated = false;

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isanimated = true;
      });
    });
  }

  _signInGoogleBtnClick() {
    // my progress indicator are showing
    Dialogue.progressIndicator(context);
    _signInWithGoogle().then((user) async {
      // my progress bar hiding or remove from stack
      Navigator.pop(context);
      if (user != null) {
        if (await Api.userExist()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          Api.createUser().then((onValue) {
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
        }
      }
    });
  }

  // google sign in code here
  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      // internet permission
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Api.auth.signInWithCredential(credential);
    } catch (e) {
      print("this is error in catch block");
      print(e.toString());
      Dialogue.showSnakbar(
          context,
          "somethig went wrong check internet connection",
          Icons.e_mobiledata,
          30);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to chat "),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: mq.height * .18,
              left: _isanimated ? mq.width * .25 : -mq.width * .25,
              width: mq.width * .5,
              child: Image.asset("images/messaging.png")),
          Positioned(
              left: mq.width * .09,
              width: mq.width * .8,
              bottom: mq.height * .15,
              top: mq.height * .66,
              child: ElevatedButton.icon(
                  onPressed: () {
                    // this function will call while click sign in with google button
                    _signInGoogleBtnClick();
                  },
                  label: Text(
                    "Sign In With Google",
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  icon: Image.asset(
                    "images/google.png",
                    height: mq.height * .05,
                  )))
        ],
      ),
    );
  }
}
