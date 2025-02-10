import 'package:chit_chat/Api/api.dart';
import 'package:chit_chat/helper/mydatetimeutil.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/models/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  // i am expecting a msg form user

  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Api.user.uid == widget.message.fromid
        ? _whiteMessage(screensize)
        : _blueMessage(screensize);
  }

  // i am creating two different that will decide msg send by current user or anther user
  // if current user uid and formid is same it means this msg send by current user and we will show blue colur widget
  Widget _blueMessage(Size screensize) {
  //if reciever and sender are different and i want to update msg that sent from my side to other side
    if ((widget.message.read ?? "").isEmpty) {
      Api.updateMessagesReadStatus(widget.message);
      print("msg are updated");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.all(screensize.width * .04),
            padding: EdgeInsets.all(screensize.width * .04),
            child: Text(widget.message.msg.toString(),
                style: TextStyle(
                    fontSize: 15, letterSpacing: 1.0, color: Colors.black87)),
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
                bottomLeft: Radius.circular(45),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: screensize.width * .04),
          child: Text(
            Mydatetimeutil.getFormattedOne(
                context: context, time: widget.message.sent!),
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _whiteMessage(Size screensize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: screensize.width * .04),
            if (widget.message.read!.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 18),
            SizedBox(
              width: 3,
            ),
            Text(
              Mydatetimeutil.getFormattedOne(
                  context: context, time: widget.message.sent!),
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.all(screensize.width * .04),
            padding: EdgeInsets.all(screensize.width * .04),
            child: Text(widget.message.msg.toString(),
                style: TextStyle(
                    fontSize: 15, letterSpacing: 1.0, color: Colors.black)),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
                bottomLeft: Radius.circular(45),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
