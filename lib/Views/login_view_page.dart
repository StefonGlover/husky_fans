import 'dart:io';

import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'forgot_password_view.dart';
import 'main_page_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Form key and variables
  final _formKey = GlobalKey<FormState>();

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Center(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Welcome to HuskyFans!',
                        style: TextStyle(
                            fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Image.asset('assets/husky_head.jpeg'),
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
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
                      SizedBox(height: 15),
                      Container(
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black),
                          child: MaterialButton(
                              onPressed: () async {
                                bool isValidated = await signIn(
                                    _emailField.text, _passwordField.text);

                                if (_formKey.currentState!.validate()) {
                                  if (isValidated) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainPageView()));
                                    _emailField.clear();
                                    _passwordField.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Incorrect email or password')));
                                  }
                                }
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterView())),
                        child: Text('No account yet? Create one',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordView())),
                        child: Text('Forgot password',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: () async {
                            await signInWithGoogle();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPageView()));

                          },
                          child: Image(
                              width: 55,
                              image: AssetImage('assets/google_logo.jpg'))),
                    ],
                  ),
                )))));
  }
}
