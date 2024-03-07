import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController emailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Password Reset Email has been sent !",
            style: TextStyle(fontSize: 20.0),
          )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "No user found for that email.",
              style: TextStyle(fontSize: 20.0),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(40),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("To Recovery the password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black45),),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      labelText: "Enter the email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = emailcontroller.text;
                        });
                        resetPassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                      onPrimary: Colors.white,
                      shadowColor: Colors.yellow,
                    ),
                    child: Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
