import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Views/account_page_view.dart';
import 'package:fan_page_app/Views/favorites_page_view.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';
import 'package:fan_page_app/Views/post_message_page.dart';

import 'package:fan_page_app/Widgets/Friends/search_bar.dart';
import 'package:fan_page_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  void dispose() {
    super.dispose();
  }


  UserInfor? _userInfor;
  double? rating;

  Future getUserProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((data) async {
      setState(() {
        var bio = data['bio'];
        var firstName = data['firstName'];
        var lastName = data['lastName'];
        var profilePic = data['profilePic'];
        var age = data['age'];
        var hometown = data['hometown'];
        var uid = data['uid'];
        var dateRegistered = data['dateRegistered'];
        var isAdmin = data['isAdmin'];

        _userInfor = UserInfor(profilePic, bio, hometown, firstName, lastName,
            age, isAdmin, dateRegistered, uid);
      });
    });
  }



  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  List<Widget> _widgetOption = <Widget>[
    FeedPage(),
    FavoritesPage(),
    SearchBar(),
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

    if (_userInfor == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('HuskyFans',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
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
            ),
          ],
        ),
        body: Center(
          child: _widgetOption.elementAt(_selectedIndex),
        ),
        floatingActionButton: new Visibility(
          visible: _userInfor!.isAdmin,
          child: new FloatingActionButton(
            onPressed: () =>
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostMessage(_userInfor)))
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.grey[900],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.view_headline), label: 'Feed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      );
    }
  }

}
