import 'package:btd/Screens/ForgetPassword.dart';
import 'package:btd/Screens/Home.dart';
import 'package:btd/Screens/Sigin.dart';
import 'package:btd/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '', password = '';

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future<void> userLogin(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Loading...'),
            content: Container(
              width: 50,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent), // Set the desired color
                ),
              ),
            ),
          );
        },
      );
     await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Close loading dialog
      Navigator.pop(context);

    void completeLogin(){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    completeLogin();
    } on FirebaseAuthException catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(40),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 7),
                          child: Text(
                            "to  BTD App",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter E-mail';
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Enter the email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Enter the password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                          }
                          userLogin(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                          onPrimary: Colors.white,
                          shadowColor: Colors.yellow,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Text(
                        'forgot password?',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'OR Login with',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        AuthMethods().signInWithGoogle(context);
                      },
                      child: Image.asset(
                        'assets/icon/google-logo.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have accout?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                'SignIn',
                                style: TextStyle(color: Colors.orangeAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
