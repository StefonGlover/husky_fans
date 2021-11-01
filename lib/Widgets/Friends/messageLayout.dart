import 'package:fan_page_app/Helpers/chat_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  String message;
  String timeSent;
  bool sentBy;

  MessageLayout(this.message, this.timeSent, this.sentBy);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentBy ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sentBy ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sentBy ? Radius.circular(24) : Radius.circular(0)),
              color: sentBy ? Colors.blue : Colors.grey[900]),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(color: sentBy ? Colors.black : Colors.white),
              ),
            ],

          ),
        )
      ],
    );
  }
}
