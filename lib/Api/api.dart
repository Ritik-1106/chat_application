import 'package:chit_chat/models/Chat_User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // return current user
  static User get user => auth.currentUser!;

  // i need create to method if user exist in data base
  static Future<bool> userExist() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }
  
  // second create new user in database if it does not present
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        image: user.photoURL.toString(),
        createAt: time.toString(),
        about: "i am busy only on call",
        isOnline: false,
        lastActive: time.toString(),
        pushToken: "");
    // we will return data to convert into json format 
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}

