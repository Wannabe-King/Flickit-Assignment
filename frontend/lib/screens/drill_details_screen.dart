import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrillDetailScreen extends StatefulWidget {
  final Map<String, dynamic> drill;
  final String userId;

  DrillDetailScreen({required this.drill, required this.userId});

  @override
  State<DrillDetailScreen> createState() => _DrillDetailScreenState();
}

class _DrillDetailScreenState extends State<DrillDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final drillCountController = TextEditingController();

  void registerDrills() async {
    if (_formKey.currentState!.validate()) {
      var drillCount = int.parse(drillCountController.text);
      try {
        final response =
            await http.post(Uri.parse('http://10.0.2.2:3000/api/submit-drill'),
                headers: {
                  "Content-Type": "application/json",
                },
                body: jsonEncode({
                  "userId": widget.userId,
                  "drillId": widget.drill['_id'],
                  "count": drillCount,
                }));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Drill Count Updated for User.")));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data['message'])));
          }
        } else {
          print(ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Internal Server Error"))));
        }
      } catch (e) {
        print(e);
      }
    }
    print("drill registerd");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drill['name']),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.drill['image'],
                height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              widget.drill['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Total Count: ${widget.drill['total_count']}"),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter username";
                        }
                        return null;
                      },
                      controller: drillCountController,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: 'Drills Completed'),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => registerDrills(), child: Text('Submit')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
