import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> signUp(BuildContext context) async {
    // const response=
    if (_formKey.currentState!.validate()) {
      var username = usernameController.text;
      var password = passwordController.text;

      final response = await http.post(
          Uri.parse("http://10.0.2.2:3000/api/signup"),
          body: {"username": username, "password": password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("User Registered Successfully. Please login now.")));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Invalid Credentials. Please Try Again!")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("There was an error signing you up. Please try again!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter username";
                        }

                        return null;
                      },
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Username')),
                  TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter username";
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => signUp(context), child: Text('Sign Up')),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text(
                      "Already have an account. Login here!",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
