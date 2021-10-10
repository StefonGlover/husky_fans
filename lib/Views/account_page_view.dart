import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/main_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'login_view_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int postCount = 0;

  void _deleteAccountAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          var _postMessage = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title: Text('Delete account',
                style: TextStyle(color: Colors.grey[900])),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (validateEmail(value!) == false) {
                          return 'Please enter a valid email';
                        }
                      },
                      autocorrect: false,
                      controller: _emailField,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black),
                          isDense: true,
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (isPasswordValid(value!) == false) {
                          return 'Please enter a valid password';
                        }
                      },
                      autocorrect: false,
                      controller: _passwordField,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black),
                          isDense: true,
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                        TextButton(
                          onPressed: () async {
                            //Need a method to validate user's password
                            if (_formKey.currentState!.validate()) {
                              if (await userReauthenticated(
                                  _emailField.text, _passwordField.text)) {
                                var collection = FirebaseFirestore.instance
                                    .collection('users');
                                await collection
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .delete();

                                await deleteUser(
                                    _emailField.text, _passwordField.text);
                                _emailField.clear();
                                _passwordField.clear();

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Incorrect email or password')));
                              }
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }


  getPostsCount() async {
    QuerySnapshot _posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> _myPostCount = _posts.docs;
    if (_myPostCount.length == null) {
      postCount = 0;
    } else {
      postCount = _myPostCount.length;
    }
    setState(() {});
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
                    child: Card(
                      child: Container(
                        height: 300,
                        width: 350,
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            CircleAvatar(
                              maxRadius: 70,
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(snapshot
                                  .data.docs[index]
                                  .data()['profilePic']),
                            ),
                            SizedBox(height: 8),
                            Text(
                              snapshot.data.docs[index].data()['bio'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 2),
                            Text(
                                snapshot.data.docs[index].data()['firstName'] +
                                    " " +
                                    snapshot.data.docs[index]
                                        .data()['lastName'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,fontSize: 15)),
                            SizedBox(height: 2),
                            Text(
                                'Hometown: ' +
                                    snapshot.data.docs[index]
                                        .data()['hometown'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Date joined: ' +
                                        snapshot.data.docs[index]
                                            .data()['dateRegistered']
                                            .toDate()
                                            .toString()
                                            .substring(0, 10),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold,)),
                                SizedBox(width: 150),
                                Text("Number of posts: $postCount",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ButtonBar(
                              children: [
                                IconButton(
                                    onPressed: _deleteAccountAlertDialog,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
