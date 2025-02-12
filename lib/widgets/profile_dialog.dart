import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/helper/font_styling.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/screens/view_user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUser user;
  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    // return InkWell(
    //   onTap: () {
    //     Navigator.pop(context);
    //     Navigator.push(context, MaterialPageRoute(builder: (_) => ViewUserProfile(user: user)));
    //   },
    // child:
    return AlertDialog(
        backgroundColor: Colors.white70,
        content: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ViewUserProfile(user: user)));
          },
          child: Container(
            height: screensize.height * .30,
            width: screensize.width * .6,
            child: Stack(
              children: [
                Text(
                  user.name!,
                  style: FontStyling.chating_text_style(Colors.black, 16),
                ),
                // icon show

                Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.info_outlined,
                        color: Colors.blue.shade400, size: 31)),

                Positioned(
                  top: screensize.height * .05,
                  left: screensize.width * .05,
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(screensize.height * 0.25),
                      child: CachedNetworkImage(
                        width: screensize.width * .5,
                        fit: BoxFit.cover,
                        imageUrl: user.image.toString(),
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
