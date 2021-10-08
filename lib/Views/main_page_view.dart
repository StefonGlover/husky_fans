import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Views/account_page_view.dart';
import 'package:fan_page_app/Views/favorites_page_view.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'login_view_page.dart';

void main() => runApp(MainPageView());

class MainPageView extends StatefulWidget {
  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  final _formKey = GlobalKey<FormState>();

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          var _postMessage = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title: Text('Share your husky moments',
                style: TextStyle(color: Colors.grey[900])),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                      },
                      autocorrect: false,
                      controller: _postMessage,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Message',
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              posts
                                  .add({
                                    'details': _postMessage.text,
                                    'firstName': 'PlaceHolder',
                                    'isFavorite': false,
                                    'photo': 'Placeholder',
                                    'uid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'timePosted':
                                        Timestamp.fromDate(DateTime.now())
                                  })
                                  .then((value) => print('Post Added'))
                                  .catchError((error) =>
                                      print('Failed to add post: $error'));

                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                          child: const Text(
                            'Post',
                            style: TextStyle(color: Colors.black),
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

  var isAdmin = false;

  void getAdmin() async {
    var a = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      isAdmin = a.docs[0]['isAdmin'];
    });
  }

  @override
  void initState() {
    super.initState();
    getAdmin();
  }

  List<Widget> _widgetOption = <Widget>[
    FeedPage(),
    FavoritesPage(),
    AccountPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('HuskyFans',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Icon(Icons.pets)
          ],
        ),
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.grey[900],
                title: const Text('Log out',
                    style: TextStyle(color: Colors.white)),
                content: const Text('Are you sure you want to log out?',
                    style: TextStyle(color: Colors.white)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      signOut();
                      signOutFromGoogle();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            child: const Icon(Icons.exit_to_app, color: Colors.white),
          )
        ],
      ),
      body: Center(
        child: _widgetOption.elementAt(_selectedIndex),
      ),
      floatingActionButton: new Visibility(
        visible: isAdmin,
        child: new FloatingActionButton(
          onPressed: () => _showDialog(),
          child: const Icon(Icons.add),
          backgroundColor: Colors.grey[900],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.view_headline), label: 'Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
