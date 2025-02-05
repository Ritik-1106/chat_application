import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/Api/api.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
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
          
        },
        child: ListTile(
          // why we use widget because widget refer state 
          title: Text(widget.user.name.toString()),
          subtitle: Text(
            widget.user.biodata
            .toString(),
            maxLines: 1,
            style: TextStyle(color: Colors.black54),
          ),
           
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(screensize.height * 0.3),
          child: CachedNetworkImage(
              height: screensize.width * 0.14,
              width: screensize.width * 0.14,
          imageUrl: widget.user.image.toString() ,
          // placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: Colors.grey.shade300 ,
              child: Icon(CupertinoIcons.person),
            ),
               ),
        ),
          trailing: Text(
            "1/03/2024",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
