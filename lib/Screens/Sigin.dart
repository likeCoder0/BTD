import 'package:btd/Screens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "", password = "", name = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();


  final _formkey = GlobalKey<FormState>();

  registration(BuildContext context) async {
    if (password.isNotEmpty &&
        nameController.text != "" &&
        emailController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Save the name to Firebase
        await userCredential.user!.updateDisplayName(name);

        // Navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));

        // Show success message after navigation
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Enter the Details",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.black26),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "To create the account",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black26),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please, Enter the name";
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Enter the name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please, Enter the email";
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Enter the email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please, Enter the password";
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Enter the password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please, Enter the password";
                          }
                          if(value!=passwordController.text){
                            return "Password is not matched!";
                          }
                          return null;
                        },
                        controller: passwordConfirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm the password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              name = nameController.text;
                              password = passwordController.text;
                            });
                          }
                          registration(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.yellow,
                        ),
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have account?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: const Text(
                                'login',
                                style: TextStyle(color: Colors.orangeAccent),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
