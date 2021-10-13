import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Views/friend_list.dart';
import 'package:fan_page_app/models/friendsList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildFriendsSearch(BuildContext context, DocumentSnapshot document) {
  final friends = Friends_List.fromSnapshot(document);

  void _viewFriendDialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          var _postMessage = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title: Text(friends.firstName =" "+friends.lastName,
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                ],
              ),
            ),
          );
        });
  }

  return new  Container(
          margin: EdgeInsets.all(10),
          child: Card(
            child: Container(
              height: 230,
              width: 350,
              child: Column(
                children: [
                  SizedBox(height: 8),
                  CircleAvatar(
                    maxRadius: 55,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(friends.profilePic),
                  ),
                  SizedBox(height: 2),
                  Text(
                      friends.firstName +
                          " " +
                          friends.lastName,
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
          )
      );



}