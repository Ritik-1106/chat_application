import "dart:convert";

import "package:chit_chat/Api/api.dart";
import "package:chit_chat/helper/dialogue.dart";
import "package:chit_chat/models/Chat_User.dart";
import "package:chit_chat/screens/auth/login_screen.dart";
import "package:chit_chat/screens/profile_screen.dart";
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
  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    Api.getSelfInfo();
  }

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

          // popup button

          PopupMenuButton(
              color: Colors.white,
              onSelected: (value) async {
                if (value == "Profile") {
                  // print("prfile options clicked");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ProfileScreen(user: Api.selfuserinfo)));
                } else if (value == 'Logout') {
                  // Perform Logout
                  await Api.auth.signOut().then((onValue) async {
                    await GoogleSignIn().signOut().then((onValue) {
                         // replacing home screen with login screen
                    Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    

                    });
                  });
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Profile',
                      child: Text(
                        "User Profile",
                        style: TextStyle(
                            fontSize: 14, fontStyle: FontStyle.normal),
                      ),
                    ),
                    PopupMenuItem(value: 'Logout', child: Text("Log Out ")),
                  ],
              icon: Icon(Icons.more_vert, color: Colors.white)),
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

          stream: Api.getAllUser(),
          builder: (context, snapshot) {
            //  check load user data on screen
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                // contain data in list
                // convert data from json to chatuser format
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];

                //  if list is empty i need to some text
                if (list.isNotEmpty) {
                  return ListView.builder(
                      itemCount: list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: list[index],
                        );
                        // return Text(list[index]);
                      });
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        size: 40,
                        color: Colors.black54,
                      ),
                      Center(
                          child: Text("No Connection Found",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54))),
                    ],
                  );
                }
            }
          }),
    );
  }
}
