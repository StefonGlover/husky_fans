import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

String getConversationID(String userID, String peerID) {
  return userID.hashCode <= peerID.hashCode
      ? userID + '_' + peerID
      : peerID + '_' + userID;
}

Future<bool> createChatRoom(String chatRoomId, chatRoomMap) async {
  try {
    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
    return true;
  } on FirebaseException catch (e) {
    return false;
    print("Error: $e");
  }
}

Future<bool> createChatRoomAndStartConversation(String friendUID) async {
  try {
   //String chatRoomID =FirebaseAuth.instance.currentUser!.uid + "_" + friendUID;

    String chatRoomID = getChatRoomId(friendUID,  FirebaseAuth.instance.currentUser!.uid);


    List<String> users = [FirebaseAuth.instance.currentUser!.uid, friendUID];

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomID
    };

    createChatRoom(chatRoomID, chatRoomMap);

    return true;
  } on FirebaseException catch (e) {
    return false;
    print("Error: $e");
  }
}

Future<bool> createConversationMessages(String chatRoomId, messageMap) async {
  try {
    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
    return true;
  } on FirebaseException catch (e) {
    return false;
    print("Error: $e");
  }
}

 getConversationMessages(String chatRoomId) async {
  try {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timeSent' )
        .snapshots();

  } on FirebaseException catch (e) {

    print("Error: $e");
  }
}

sendMessage(String chatRoomId, String message, String friendUID) {
  //messageMap: Who sent it(uid), message, and timestamp
  Map<String, dynamic> messageMap = {
    "message": message,
    "sentBy": FirebaseAuth.instance.currentUser!.uid,
    "timeSent": Timestamp.fromDate(DateTime.now())
  };

  createConversationMessages(chatRoomId, messageMap);
}

getUserChats() async {
  return await FirebaseFirestore.instance
      .collection("chatRoom")
      .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

getChatRoomId(String a, String b)
{
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
    {
      return "$b\_$a";
    }
  else
    {
      return "$a\_$b";
    }
}

