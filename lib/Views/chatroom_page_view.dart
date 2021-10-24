import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/chat_functions.dart';
import 'package:fan_page_app/Widgets/conversation.dart';
import 'package:fan_page_app/Widgets/send_message.dart';
import 'package:fan_page_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  UserInfor chatWithUser;

  ChatRoomPage({Key? key, required this.chatWithUser}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  static String? chatRoomID;

  @override
  void initState() {
    super.initState();
    chatRoomID = getChatRoomId(
        widget.chatWithUser.uid, FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20)))),
        home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Column(
              children: [
                CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(widget.chatWithUser.profilePic),
                ),
                SizedBox(height: 3),
                Text(
                  widget.chatWithUser.firstName,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            backgroundColor: Colors.grey[900],
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                  flex: 9,
                  child: Column(
                    children: [Conversation(chatRoomID: chatRoomID)],
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[900],
                    height: double.infinity,
                    child: SendMessage(
                        chatRoomID: chatRoomID!,
                        friendUID: widget.chatWithUser.uid),
                  )),
            ],
          ),
        ));
  }
}
