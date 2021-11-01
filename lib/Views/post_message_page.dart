import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Views/account_page_view.dart';
import 'package:fan_page_app/Views/favorites_page_view.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';

import 'package:fan_page_app/Widgets/Friends/search_bar.dart';
import 'package:fan_page_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PostMessage extends StatefulWidget {
  UserInfor? _userInfor;

  PostMessage(this._userInfor);

  @override
  State<PostMessage> createState() => _PostMessageState();
}

class _PostMessageState extends State<PostMessage> {
  final _formKey = GlobalKey<FormState>();

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  File? _image;

  final picker = ImagePicker();

  Future pickImage() async {
    try {
      final image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);

      setState(() {
        if (image != null) {
          _image = File(image.path);
        } else {
          print('No image selected');
        }
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

  @override
  Widget build(BuildContext context) {
    var _postMessage = TextEditingController();
    if (widget._userInfor == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ));
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)))),
          home: Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Share your husky moments',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(Icons.pets)
                ],
              ),
              backgroundColor: Colors.grey[900],
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _image != null
                                    ? FileImage(_image!) as ImageProvider
                                    : AssetImage("assets/uploadPic.jpg"),
                                fit: BoxFit.fill)),
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
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String url = await uploadPostImage();
                            posts
                                .add({
                                  'details': _postMessage.text,
                                  'firstName': widget._userInfor!.firstName,
                                  'isFavorite': false,
                                  'photo': url,
                                  'uid': FirebaseAuth.instance.currentUser!.uid,
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
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    }
  }
}
