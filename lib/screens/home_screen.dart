import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          CupertinoIcons.home,
          color: Colors.white,
        ),
        title: Text("chate kro"),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
              color: Colors.white)
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            onPressed: () async {
              // when you press button you sign out from current account
               await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add, color: Colors.white)),
      ),
    );
  }
}
