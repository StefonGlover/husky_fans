import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class RegisterForms extends StatefulWidget {
  const RegisterForms({Key? key}) : super(key: key);

  @override
  _RegisterFormsState createState() => _RegisterFormsState();
}

class _RegisterFormsState extends State<RegisterForms> {
  final _formKey = GlobalKey<FormState>();

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _confirmPasswordField = TextEditingController();
  TextEditingController _firstNameField = TextEditingController();
  TextEditingController _lastNameField = TextEditingController();
  TextEditingController _bioField = TextEditingController();
  TextEditingController _hometownField = TextEditingController();
  TextEditingController _ageField = TextEditingController();

  /// The variable and method below allows the user to pick an image
  /// from their gallery
  /// @params none
  /// returns void
  File? _image;

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

  /// This method obtains the url of the profile pic
  /// @params none
  /// returns String url
  /// This method obtains the url of the profile pic
  /// @params none
  /// returns String url
  Future<String> uploadProfileImage() async {
    try {
      String time = DateTime.now().toString();
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref()
          .child("profilePics")
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
    return SingleChildScrollView(
        child: Center(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Create your account. It\'s free and only takes a minute!',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
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
                    return 'Please enter a short bio';
                  }
                },
                autocorrect: false,
                controller: _bioField,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: Colors.black),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.menu_book_outlined,
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your hometown';
                  }
                },
                autocorrect: false,
                controller: _hometownField,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Hometown',
                    labelStyle: TextStyle(color: Colors.black),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.home,
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
                  if (value == null || value.isEmpty) {
                    return 'Must be 18 or older to register';
                  }
                },
                autocorrect: false,
                controller: _ageField,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Age (number)',
                    labelStyle: TextStyle(color: Colors.black),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.calculate,
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                },
                autocorrect: false,
                controller: _firstNameField,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'First name',
                    labelStyle: TextStyle(color: Colors.black),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                },
                autocorrect: false,
                controller: _lastNameField,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Last name',
                    labelStyle: TextStyle(color: Colors.black),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
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
                    return 'Password must be greater than 8 characters';
                  }
                },
                autocorrect: false,
                obscureText: true,
                controller: _passwordField,
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
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (isPasswordValid(value!) == false) {
                    return 'Password must be greater than 8 characters';
                  }
                  if (!_passwordField.text
                      .contains(_confirmPasswordField.text)) {
                    return 'Passwords do not match';
                  }
                },
                autocorrect: false,
                obscureText: true,
                controller: _confirmPasswordField,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Confirm password',
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
              SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black),
                  child: MaterialButton(
                      onPressed: () async {
                        var timeRegistered;
                        if (_passwordField.text
                            .contains(_confirmPasswordField.text)) {
                          if (_formKey.currentState!.validate()) {
                            String profilePic;

                            bool isUserValidated = await register(
                                _bioField.text,
                                _hometownField.text,
                                _ageField.text,
                                _emailField.text,
                                _passwordField.text,
                                _firstNameField.text,
                                _lastNameField.text,
                                profilePic = (await uploadProfileImage()),
                                timeRegistered =
                                    Timestamp.fromDate(DateTime.now()));

                            if (isUserValidated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Registration successful')));
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Error. Email may be in use')));
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')));
                        }
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )))
            ],
          )),
    ));
  }
}
