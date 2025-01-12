import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void login(BuildContext context) async {
    // Call backend API to authenticate user
    if (_formKey.currentState!.validate()) {
      var username = usernameController.text;
      var password = passwordController.text;

      final response =
          await http.post(Uri.parse("http://10.0.2.2:3000/api/login"),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({"username": username, "password": password}));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['success'] == true) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(userId: data['userId'])));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Invalid Credentials. Please Try Again!")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("There was an error while login. Please try again!")));
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
                    "Login",
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
                      onPressed: () => login(context), child: Text('Login')),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignupScreen())),
                    child: Text(
                      "Don't have an account. Please Sign Up here.",
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
