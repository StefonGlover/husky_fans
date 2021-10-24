import 'package:fan_page_app/Helpers/chat_functions.dart';
import 'package:fan_page_app/Widgets/messageLayout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  String? chatRoomID;

  Conversation({required this.chatRoomID});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomID)
          .collection('chats')
          .orderBy('timeSent')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final data = snapshot.requireData;

        return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return MessageLayout(
                  data.docs[index]['message'],
                  data.docs[index]['timeSent'].toDate()
                      .toString()
                      .substring(0, 16),
                  data.docs[index]['sentBy'] ==
                      FirebaseAuth.instance.currentUser!.uid);
            });
      },
    ));
  }
}
