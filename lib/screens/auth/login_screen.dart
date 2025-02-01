import "dart:math";

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
    _signInWithGoogle().then((user) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  // google sign in code here

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
                    "Log In With Google",
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
