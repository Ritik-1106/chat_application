import "package:chit_chat/Api/api.dart";
import "package:chit_chat/helper/dialogue.dart";
import "package:chit_chat/models/Chat_User.dart";
import "package:chit_chat/screens/auth/login_screen.dart";
import "package:chit_chat/screens/profile_screen.dart";
import "package:chit_chat/widgets/chat_user_card.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  // it store search items
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Api.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Icon(
          _isSearching ? null : CupertinoIcons.home,
          color: Colors.white,
        ),

        title: _isSearching
            ? TextField(
                cursorColor: Colors.white70,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search Name or Email',
                    hintStyle: TextStyle(color: Colors.white60)),
                onChanged: (value) {
                  setState(() {
                    _searchList.clear(); // Clear previous search results
                    for (var i in _list) {
                      // Convert both to lowercase for case-insensitive search
                      if (i.name!.toLowerCase().contains(value.toLowerCase()) ||
                          i.email!
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                        _searchList.add(i);
                      }
                    }
                  });
                })
            : Text("Chit Chat")
        title: Text("Chit Chat", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: Colors.white)),

          // popup button
          if (!_isSearching)
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
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
                _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                //  if list is empty i need to some text

                print(_searchList.length);
                print(_list.length);
                if (_list.isNotEmpty) {
                  return ListView.builder(
                      // if issearch is true so we will show searchlist otherwise list
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
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
