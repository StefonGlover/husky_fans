import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(ForgotPasswordView());

class ForgotPasswordView extends StatelessWidget {
  //Form key and variables
  final _formKey = GlobalKey<FormState>();

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
          backgroundColor: Colors.grey[900]
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('Enter your email and we\'ll send you a link to reset your password.', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                SizedBox(height: 30),
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
                Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black),
                    child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            resetPassword(_emailField.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Your password reset email has been sent!')));
                            Navigator.pop(context);

                          }
                        },
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
              ],
            ),
          ),

        ),

      ),
    );
  }
}
