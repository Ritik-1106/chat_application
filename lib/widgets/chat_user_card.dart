
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: screensize.width * .020, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          
        },
        child: ListTile(
          title: Text("User"),
          subtitle: Text(
            "fgfgdf",
            maxLines: 1,
            style: TextStyle(color: Colors.black54),
          ),
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
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
