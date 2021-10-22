import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Views/account_page_view.dart';
import 'package:fan_page_app/Views/favorites_page_view.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';

import 'package:fan_page_app/Widgets/search_bar.dart';
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
  final _formKey = GlobalKey<FormState>();

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  File? _image;

  @override
  void dispose() {
    _image;
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      final image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> uploadPostImage() async {
    try {
      String time = DateTime.now().toString();
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref()
          .child("posts")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('$time')
          .putFile(_image!);

      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed upload image: $e');

      //Default image
      return "https://firebasestorage.googleapis.com/v0/b/fan-page-app-585d5.appspot.com/o/profilePics%2Fhusky_head.jpeg?alt=media&token=dd57f98a-2817-4107-9280-a51fa171d267";
    }
  }

  UserInfor? _userInfor;

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
            child: CircularProgressIndicator(

            ),
          ),
        )
      );
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
            onPressed: _showDialog,
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
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.black,
                        backgroundImage: _image != null
                            ? FileImage(_image!) as ImageProvider
                            : AssetImage("assets/husky_head.jpeg"),
                        child: Stack(children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white70,
                              child: Icon(
                                CupertinoIcons.camera,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: 20),
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
                          onPressed: () async {
                            String url = await uploadPostImage();
                            if (_formKey.currentState!.validate()) {
                              posts
                                  .add({
                                    'details': _postMessage.text,
                                    'firstName': _userInfor!.firstName,
                                    'isFavorite': false,
                                    'photo': url,
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
}
