//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/Api/api.dart';
import 'package:chit_chat/helper/Dialogue.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  // we need to create user of ChatUser model
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // i need to global key to control on widget like textformwidget
  final GlobalKey<FormState> _formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    return GestureDetector(
      // this line will hide to keyword when you click on anywhere on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            " User Profile",
            style: TextStyle(
                fontSize: 30, fontStyle: FontStyle.normal, color: Colors.white),
          ),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screensize.width * .15),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screensize.height * .05),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(screensize.height * .1),
                        child: CachedNetworkImage(
                          height: screensize.width * 0.3,
                          width: screensize.width * 0.3,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image.toString(),
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          shape: CircleBorder(),
                          color: Colors.white,
                          onPressed: () {},
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screensize.height * .03),
                  Text(widget.user.email!,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.normal,
                          fontSize: 22)),
                  SizedBox(height: screensize.height * .03),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (newValue) {
                      Api.selfuserinfo.name = newValue ?? "";
                    },

                    // i want to use or apply some condition using validator
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    cursorColor: Colors.blue,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.person, color: Colors.blue.shade300),
                        hintText: "eg: ritik nagar",
                        hintStyle: TextStyle(color: Colors.black54),
                        label: Text("Name"),
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue.shade200)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                  SizedBox(height: screensize.height * .03),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (newValue) {
                      Api.selfuserinfo.about = newValue ?? "";
                    },

                    // i want to use or apply some condition using validator
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "required field",
                    cursorColor: Colors.blue,
                    cursorHeight: 25,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.info,
                          color: Colors.blue.shade300,
                        ),
                        label: Text("About"),
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue.shade200)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                  SizedBox(height: screensize.height * .04),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          Api.updateInfo().then((value) {
                            Dialogue.showSnakbar(context, "Updated Succesfully",
                                Icons.update, 25);
                          });
                        }
                      },
                      icon: Icon(Icons.update_rounded),
                      label: Text("Update"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                          iconSize: 20)),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Dialogue.progressIndicator(context);
            await Api.auth.signOut().then((onValue) async {
              await GoogleSignIn().signOut().then((onValue) {
                Navigator.pop(context);

                // for moving to home screen
                Navigator.pop(context);

                // replacing home screen with login screen
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
                Dialogue.showSnakbar(
                    context, "Sign Out Successfully", Icons.back_hand, 25);
              });
            });
          },
          backgroundColor: Colors.blue,
          icon: Icon(Icons.logout, color: Colors.white),
          label: Text("Logout",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }
}
