import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/Api/api.dart';
import 'package:chit_chat/helper/mydatetimeutil.dart';
import 'package:chit_chat/helper/ui_helper.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/models/Message.dart';
import 'package:chit_chat/screens/view_user_profile.dart';
import 'package:chit_chat/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  List<Message> _list = [];
  final _texteditingcontroller = TextEditingController();
  bool _isshowEmoji = false;
  
  // this is initstate when this screen will build firstly this is first method that will call or intialize 
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      UIHelper.setDefaultUIStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        // with the help of popscope when you try to back first of
        //all emoji section will hide and you will back from screen
        child: PopScope(
          canPop: !_isshowEmoji,
          onPopInvokedWithResult: (didPop, result) {
            if (_isshowEmoji) {
              setState(() {
                _isshowEmoji = !_isshowEmoji;
              });
            } else {
              // Exit the app if not searching
              Navigator.of(context).maybePop();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.blue.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appbar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      // using steam parameter we load to data
                      stream: Api.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        //  check load user data on screen
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            // print("data: ${jsonEncode(data![0].data())}");
                            // contain data in list
                            // convert data from json to chatuser format
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  // this reverse parameter automatically scroll on latest message or last message
                                  reverse: true,
                                  // if issearch is true so we will show searchlist otherwise list
                                  itemCount: _list.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MessageCard(message: _list[index]);
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
                _chatInput(),
                // this code to show emoji
                if (_isshowEmoji)
                  SizedBox(
                    height: 200,
                    child: EmojiPicker(
                      textEditingController:
                          _texteditingcontroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        height: 200,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                        ),
                        viewOrderConfig: const ViewOrderConfig(
                          top: EmojiPickerItem.categoryBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.searchBar,
                        ),
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(
                            buttonColor: Colors.white,
                            buttonIconColor: Colors.blue,
                            backgroundColor: Colors.white),
                        searchViewConfig: const SearchViewConfig(
                          hintText: "Search Emoji",
                          hintTextStyle:
                              TextStyle(fontSize: 20, color: Colors.black54),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewUserProfile(user: widget.user)));
      },
      child: StreamBuilder(
        stream: Api.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          if (list.isNotEmpty) {}

          return Row(
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
                    widget.user.name.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 1),
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline!
                            ? 'Online'
                            : Mydatetimeutil.getLastTimeActive(
                                context: context,
                                lastactive: list[0].lastActive.toString())
                        : Mydatetimeutil.getLastTimeActive(
                            context: context,
                            lastactive: widget.user.lastActive.toString()),
                    style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.0,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          );
        },
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          // it will change value if false so it will true
                          _isshowEmoji = !_isshowEmoji;
                        });
                      },
                      icon: Icon(Icons.emoji_emotions,
                          size: 25, color: Colors.blue)),
                  Expanded(
                      child: TextField(
                          enableInteractiveSelection: false,
                          onTap: () {
                            if (_isshowEmoji) {
                              // isemoji is true it means emoji keyborad is open first we need to close
                              // then open simple keyboard
                              setState(() {
                                _isshowEmoji = !_isshowEmoji;
                              });
                            }
                          },
                          controller: _texteditingcontroller,
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
            onPressed: () {
              if (_texteditingcontroller.text.isNotEmpty) {
                Api.sendMessage(widget.user, _texteditingcontroller.text);
                _texteditingcontroller.text = '';
              }
            },
            color: Colors.blue,
            minWidth: 0,
            shape: CircleBorder(),
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 2),
            child: Icon(Icons.send, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }
}
