import 'package:fan_page_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  UserInfor chatWithUser;

  ChatRoomPage({Key? key, required this.chatWithUser}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
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
        body: Center(
          child: Text(widget.chatWithUser.lastName),
        ));
  }
}
