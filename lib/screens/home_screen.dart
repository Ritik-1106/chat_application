import "package:chit_chat/Api/api.dart";
import "package:chit_chat/helper/Dialogue.dart";
import "package:chit_chat/helper/font_styling.dart";
import "package:chit_chat/models/Chat_User.dart";
import "package:chit_chat/screens/auth/login_screen.dart";
import "package:chit_chat/screens/profile_screen.dart";
import "package:chit_chat/widgets/chat_user_card.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
  void initState(){
    super.initState();
    Api.getSelfInfo();
    // first we need show user is active when application will start

   Api.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Api.auth.currentUser != null) {
        print("abhi current user null nhi h");
        if (message.toString().contains('resumed')) {
          print("abhi resume h screen ");
          Api.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          Api.updateActiveStatus(false);
        print("abhi pause h screen ");
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
            canPop: !_isSearching,
            onPopInvokedWithResult: (didPop, result) {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
              } else {
                // Exit the app if not searching
                Navigator.of(context).maybePop();
              }
            },
            child: Scaffold(
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
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search Name or Email',
                              hintStyle: TextStyle(color: Colors.white60)),
                          onChanged: (value) {
                            setState(() {
                              _searchList
                                  .clear(); // Clear previous search results
                              for (var i in _list) {
                                // Convert both to lowercase for case-insensitive search
                                if (i.name!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    i.email!
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                  _searchList.add(i);
                                }
                              }
                            });
                          })
                      : Text("Chit&Chat", style: FontStyling.title01()),
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
                    if (!_isSearching)
                      PopupMenuButton(
                          color: Colors.white,
                          onSelected: (value) async {
                            if (value == "Profile") {
                              // print("prfile options clicked");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProfileScreen(
                                          user: Api.selfuserinfo)));
                            } else if (value == 'Logout') {
                              // First, update Firestore before signing out
                              await Api.updateActiveStatus(false);
                              // Perform Logout
                              await Api.auth.signOut().then((onValue) async {
                                await GoogleSignIn().signOut().then((onValue) {
                                  // replacing home screen with login screen
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => LoginScreen()));

                                  // we are new instance intailze
                                  Api.auth = FirebaseAuth.instance;
                                  // show snak bar
                                  Dialogue.showSnakbar(
                                      context,
                                      "Sign Out Successfully",
                                      Icons.back_hand,
                                      25);
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
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                                PopupMenuItem(
                                    value: 'Logout', child: Text("Log Out ")),
                              ],
                          icon: Icon(Icons.more_vert, color: Colors.white)),
                  ],
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
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];
                          //  if list is empty i need to some text
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                // if issearch is true so we will show searchlist otherwise list
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
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
                    }))));
  }
}
