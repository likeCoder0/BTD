import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:btd/Screens/NavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _image;
  String _predictedClass =
      'Predicted class: not predict'; // Initialize with default value
  Future<void>? _predictFuture;

  Future<void> _chooseImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _predictImage() async {
    if (_image == null) return;

    final apiUrl =
        'http://192.168.108.57:5000/predict'; // Replace with your API URL

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Predicting Image...'),
          content: Container(
            width: 50,
            height: 50,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orangeAccent), // Set the desired color
              ),
            ),
          ),
        );
      },
    );

    try {
      final response = await request
          .send()
          .timeout(Duration(seconds: 10)); // Add a timeout of 10 seconds

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        String predictedClass = jsonResponse['predicted_class'];

        Navigator.pop(context); // Close the loading dialog

        setState(() {
          _predictedClass = 'Predicted class: $predictedClass';
        });

        // Show the pop-up message using AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Prediction Done'),
              content: Text('Prediction completed: $predictedClass'),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.pop(context); // Close the loading dialog
        print('Request failed with status: ${response.statusCode}');

        // Show the error message in the pop-up
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Prediction Error'),
              content: Text('Failed to predict. Please try again later.'),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      Navigator.pop(context); // Close the loading dialog
      print('Exception: $error');

      // Show the error message in the pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Prediction Error'),
            content: Text(
                'An error occurred while predicting. Please try again later.'),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        context: context,
      ),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 350, // Width of the image frame
                height: 350, // Height of the image frame
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: _image == null
                    ? const Center(child: Text('No image selected.'))
                    : Image.file(_image, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _chooseImage,
                child: const Text(
                  'Choose Image',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orangeAccent),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _predictImage,
                child: const Text(
                  'Predict',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orangeAccent),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350, // Width of the predicted frame
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red.shade100,
                    width: 5.0,
                  ),
                ),
                child: Text(
                  _predictedClass, // Display the predicted class here
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
