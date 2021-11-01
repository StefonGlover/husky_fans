import 'dart:ffi';

import 'package:fan_page_app/Helpers/chat_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatelessWidget {

  String chatRoomID, friendUID;

  SendMessage({required this.chatRoomID, required this.friendUID});

  TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20),
        Expanded(
            child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return;
            }
          },
          autocorrect: false,
          controller: _messageController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: 'Message',
              isDense: true,
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              prefixIcon: Icon(
                Icons.pets,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20))),
        )),
        IconButton(
            onPressed: () async
                {
                  createChatRoomAndStartConversation(friendUID);
                  sendMessage(chatRoomID, _messageController.text, friendUID);
                  _messageController.clear();
                },
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ))
      ],
    );
  }
}
