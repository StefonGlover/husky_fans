import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                    textAlign: TextAlign.center,),
                  SizedBox(height: 20),
                  Image.asset('assets/husky_head.jpeg', height: 180),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.4,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black),
                      child: MaterialButton(
                          onPressed: () async {
                            final DateTime now = DateTime.now();
                            final DateFormat formatter = DateFormat('MM-dd-yyyy');
                            final String formatted = formatter.format(now);

                            if (_passwordField.text
                                .contains(_confirmPasswordField.text)) {
                              if (_formKey.currentState!.validate()) {
                                bool isUserValidated = await register(
                                    _emailField.text,
                                    _passwordField.text,
                                    _firstNameField.text,
                                    _lastNameField.text,

                                    formatted);

                                if (isUserValidated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text('Registration successful')));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text('Error. Email may be in use')));
                                }
                              }
                            }
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )))
                ],
              )),
        ));
  }
}
