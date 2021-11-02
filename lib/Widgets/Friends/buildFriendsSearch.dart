import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/chat_functions.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Helpers/ranking_methods.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/chatroom_page_view.dart';
import 'package:fan_page_app/Widgets/Rating/rating.dart';
import 'package:fan_page_app/Widgets/Rating/view_friend_rating.dart';

import 'package:fan_page_app/models/friendsList.dart';
import 'package:fan_page_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Widget buildFriendsSearch(BuildContext context, DocumentSnapshot document) {
  final friends = Friends_List.fromSnapshot(document);
  TextEditingController _ratingController = new TextEditingController();
  double ranking = 0;

  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {

  }

  UserInfor getFriendObject() {
    return UserInfor(
        friends.profilePic,
        friends.bio,
        friends.hometown,
        friends.firstName,
        friends.lastName,
        friends.age,
        friends.isAdmin,
        friends.dateRegistered,
        friends.uid);
  }

  void _viewFriendDialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          var _postMessage = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title: Text(
              friends.firstName + " " + friends.lastName,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(friends.profilePic),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Bio: ' + friends.bio,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Hometown: ' + friends.hometown,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Age: ' + friends.age,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: 100,
                    color: Colors.grey[900],
                    child: TextButton(
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoomPage(
                                      chatWithUser: getFriendObject())));
                        },
                        child: Text('Message',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _rateUser() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              friends.firstName + " " + friends.lastName,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(friends.profilePic),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
                        ],
                        validator: (value) {
                          if (double.tryParse(value!)! < 0 ||
                              double.tryParse(value!)! > 5) {
                            return 'Enter a number between 0 and 5';
                          }
                        },
                        autocorrect: false,
                        controller: _ratingController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            labelText: 'Rank',
                            labelStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.pets,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 100,
                        color: Colors.grey[900],
                        child: TextButton(
                            onPressed: () async {
                              double? rank =
                                  double.tryParse(_ratingController.text);

                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                RankingMethods().sendRank(friends.uid, rank!);
                              }
                            },
                            child: Text('Rank',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  return new Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Container(
          height: 250,
          width: 350,
          child: Column(
            children: [
              GetFriendRank(friends.uid),
              SizedBox(height: 8),
              CircleAvatar(
                maxRadius: 55,
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(friends.profilePic),
              ),
              SizedBox(height: 2),
              Text(friends.firstName + " " + friends.lastName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: 2),
              Text(
                  'Date joined: ' +
                      friends.dateRegistered
                          .toDate()
                          .toString()
                          .substring(0, 10),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () {
                        _rateUser();
                      },
                      child: Text(
                        'Rank user',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                  IconButton(
                      onPressed: () {
                        _viewFriendDialog();
                      },
                      icon: Icon(
                        Icons.info,
                        color: Colors.black,
                      ))
                ],
              ),
            ],
          ),
        ),
      ));
}


