import "dart:convert";

import "package:chit_chat/Api/api.dart";
import "package:chit_chat/helper/dialogue.dart";
import "package:chit_chat/screens/auth/login_screen.dart";
import "package:chit_chat/widgets/chat_user_card.dart";
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
        title: Text("Chit Chat", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
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
              try {
                await Api.auth.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
                Dialogue.showSnakbar(
                    context, "User Has Sign out", Icons.back_hand_rounded, 25);
              } catch (e) {
                Dialogue.showSnakbar(
                    context, "kuch toh gadbad h daya", Icons.error, 30);
              }
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add, color: Colors.white)),
      ),
      body: StreamBuilder(
          // using steam parameter we load to data

          stream: Api.firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            final list = [];
            // if snapshot has data
            if (snapshot.hasData) {
              // data should not be null otherwise you will get error
              final data = snapshot.data?.docs;
              for (var i in data!) {
                print(jsonEncode(i.data())); 
                list.add(i.data()['name']);
              }
            }
            return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Text(list[index]);
                });
          }),
    );
  }
}
