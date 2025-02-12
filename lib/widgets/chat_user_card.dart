import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/Api/api.dart';
import 'package:chit_chat/helper/mydatetimeutil.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/models/Message.dart';
import 'package:chit_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last msg info (if null -- no message)
  Message? _message;
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
          horizontal: screensize.width * .020, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
          onTap: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },

          // i want to update entire list tile or listview so i sued streambuilder
          child: StreamBuilder(
              stream: Api.getLastMessages(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }

                return ListTile(
                    // why we use widget because widget refer state
                    title: Text(widget.user.name.toString()),
                    subtitle: Text(
                      _message?.msg ??
                          widget.user.biodata ??
                          "you are on chit chat ",
                      maxLines: 1,
                      style: TextStyle(color: Colors.black54),
                    ),
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(screensize.height * 0.3),
                      child: CachedNetworkImage(
                        height: screensize.width * 0.14,
                        width: screensize.width * 0.14,
                        imageUrl: widget.user.image.toString(),
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read!.isEmpty &&
                                _message!.fromid != Api.user.uid
                            ? StreamBuilder(
                                stream: Api.getUnreadMessages(
                                    widget.user), // Fetch unread messages
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox(); // No unread messages, hide the blue dot
                                  } 
                                int unreadCount = snapshot.data!.docs.length ;
                                  return Container(
                                    padding: EdgeInsets.all(
                                        screensize.width * .001),
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      unreadCount
                                          .toString(), // Show unread count
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              )
                            : 
                            
                            Text(
 
                                Mydatetimeutil.getlastMessageTime(
                                    context: context,
                                    sent_time: _message!.sent.toString()),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              
                              
                              )
                            );
                          }
                        )
                      ),
                    );
                  }
}
