//

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/Api/api.dart';
import 'package:chit_chat/helper/Dialogue.dart';
import 'package:chit_chat/helper/font_styling.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker picker = ImagePicker();
  String? _image;
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    return GestureDetector(
      // this line will hide to keyword when you click on anywhere on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("MY Profile", style: FontStyling.title01()),
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
                      _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(screensize.height * .1),
                              child: Image.file(
                                File(_image!),
                                height: screensize.width * 0.3,
                                width: screensize.width * 0.3,
                                fit: BoxFit.cover,
                              ))
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(screensize.height * .1),
                              child: CachedNetworkImage(
                                height: screensize.width * 0.3,
                                width: screensize.width * 0.3,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image.toString(),
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
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
                          onPressed: () {
                            _showBottomSheet();
                          },
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
                    initialValue: widget.user.biodata,
                    onSaved: (newValue) {
                      Api.selfuserinfo.biodata = newValue ?? "";
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
                      label: Text("Update", style: FontStyling.button_text(Colors.white, 14)),
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

            // First, update Firestore before signing out
            await Api.updateActiveStatus(false);
            await Api.auth.signOut().then((onValue) async {
              await GoogleSignIn().signOut().then((onValue) {

                
                              
                Navigator.pop(context);

                // for moving to home screen
                Navigator.pop(context);


              // we are new instance intailze 
                Api.auth = FirebaseAuth.instance;

                
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
          label: Text("LogOut", style: FontStyling.button_text(Colors.white, 16)),
        ),
      ),
    );
  }

  //  show model bottom sheet that will provide pick image option from gallery and file manager
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 30, bottom: 100),
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          // if image is not so i am gonna remove this bottom sheet from screen so i will pop
                          setState(() {
                            // update to current selected image path in global variable
                            _image = image.path;
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(110, 110)),
                      child: Image.asset(
                        "images/camera01.png",
                        fit: BoxFit.cover,
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        // Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          print(image.path);
                          // if image is not so i am gonna remove this bottom sheet from screen so i will pop
                          setState(() {
                            // update to current selected image path in global variable
                            _image = image.path;
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(110, 110)),
                      child: Image.asset(
                        "images/gallery.png",
                        fit: BoxFit.cover,
                      ))
                ],
              )
            ],
          );
        });
  }
}
