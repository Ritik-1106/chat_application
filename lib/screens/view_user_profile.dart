import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat/helper/font_styling.dart';
import 'package:chit_chat/helper/mydatetimeutil.dart';
import 'package:chit_chat/models/Chat_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewUserProfile extends StatefulWidget {
  final ChatUser user;
  const ViewUserProfile({super.key, required this.user});

  @override
  State<ViewUserProfile> createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
   // i need to global key to control on widget like textformwidget
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
          title: Text("User Profile", style: FontStyling.title01()),
        ),
        body: Form(
          
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
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
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
                    readOnly: true,
                    initialValue: widget.user.name,
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
                    readOnly: true,
                    initialValue: widget.user.biodata,
                   enableInteractiveSelection: false,
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
                  SizedBox(height: screensize.height * 0.33),

                  Text("joined on "+ Mydatetimeutil.joined_time(context: context, create_time: widget.user.createAt!)
                    
                 ,style: TextStyle(color: Colors.black54, fontSize: 16),)
                 
                ],
              ),
            ),
          ),
        ),
        
      ),
    );
  }

}
