import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  int postCount = 0;

  getPostsCount() async
  {
    QuerySnapshot _posts = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    List<DocumentSnapshot> _myPostCount = _posts.docs;
    if(_myPostCount.length == null)
    {
      postCount = 0;
    }
    else
    {
      postCount = _myPostCount.length;
    }
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsCount();
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: users
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: new Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          title: Text(
                              snapshot.data.docs[index].data()['firstName'] +
                                  '\n' +
                                  snapshot.data.docs[index].data()['lastName'] +
                                  '\n',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text("Number of posts: $postCount"+"\n"
                              "Email: " +
                                  FirebaseAuth.instance.currentUser!.email
                                      .toString() +
                                  '\n'
                                      'Date joined: ' +
                                  snapshot.data.docs[index]
                                      .data()['dateRegistered']
                                      .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        ButtonBar(
                          children: [
                            TextButton(
                                onPressed: null,
                                child: Text(
                                  'Update Profile',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
