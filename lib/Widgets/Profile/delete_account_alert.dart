import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/login_view_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future accountDeleteAlert(BuildContext context) {

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
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
    },
  );
}