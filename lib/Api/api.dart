import 'package:chit_chat/models/Chat_User.dart';
import 'package:chit_chat/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static late ChatUser selfuserinfo;
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

  // for current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        selfuserinfo = ChatUser.fromJson(user.data()!);
        print(user.data());
      } else {
        await createUser().then((onValue) {
          getSelfInfo();
        });
      }
    });
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
        isOnline: false,
        lastActive: time.toString(),
        biodata: "love......",
        pushToken: "");
    // we will return data to convert into json format
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return Api.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // get user info for single user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatuser) {
    return Api.firestore
        .collection('users')
        .where('id', isEqualTo: chatuser.id)
        .snapshots();
  }

  //  this api will update to last_active and is_online field
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  static updateInfo() {
    print("chal bhai tu update kr");
    return Api.firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': selfuserinfo.name, 'biodata': selfuserinfo.biodata});
  }

// chat screen related api
  // chats(collection) => conversation_id(doc) => messages(collection) => message(doc)

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // this api basically retrive all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return Api.firestore
        .collection('chats/${getConversationID(user.id!)}/messages/').orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(ChatUser chatuser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch;

    final Message message = Message(
        told: chatuser.id,
        sent: time.toString(),
        fromid: user.uid,
        msg: msg,
        read: '',
        type: "String");
    final ref = firestore
        .collection('chats/${getConversationID(chatuser.id!)}/messages/');
    await ref.doc(time.toString()).set(message.toJson());
  }

  // for updating read messages
  static Future<void> updateMessagesReadStatus(Message msg) async {
    firestore
        .collection('chats/${getConversationID(msg.fromid!)}/messages/')
        .doc(msg.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

// i want to show last msg
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return Api.firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMessages(
      ChatUser user) {
    return Api.firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .where('read', isEqualTo: "") // Filter unread messages
        .snapshots();
  }

  static Future<void> loginUser() async {
    final current_user = auth.currentUser;
    await firestore
        .collection('users')
        .doc(current_user!.uid)
        .update({'isOnline': true});
  }
}
