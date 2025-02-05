import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chit_chat/screens/splash_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, statusBarColor: Colors.blue));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  // using steam parameter we load to data
                  stream: null,
                  // stream: Api.getAllUser(),
                  builder: (context, snapshot) {
                    //  check load user data on screen
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return Center(child: CircularProgressIndicator());

                      case ConnectionState.active:
                      case ConnectionState.done:
                        // final data = snapshot.data?.docs;
                        // contain data in list
                        // convert data from json to chatuser format
                        // _list = data
                        //         ?.map((e) => ChatUser.fromJson(e.data()))
                        //         .toList() ??
                        //     [];

                        //  if list is empty i need to some text
                        final _list = ["sam", "v"];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              // if issearch is true so we will show searchlist otherwise list
                              itemCount: _list.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Text(_list[index]);
                              });
                        } else {
                          return Center(
                              child: Text("Say Hii",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54)));
                        }
                    }
                  }),
            ),
            _chatInput()
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                height: 50,
                width: 60,
                fit: BoxFit.cover,
                imageUrl: widget.user.image.toString(),
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ritik Nagar",
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1),
              Text(
                "Ritik Nagar",
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.0,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions,
                          size: 25, color: Colors.blue)),
                  Expanded(
                      child: TextField(
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Type something...",
                              border: InputBorder.none))),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.blue,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blue,
                        size: 26,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            minWidth: 0,
            shape: CircleBorder(),
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 2),
            onPressed: () {},
            child: Icon(Icons.send, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }
}
