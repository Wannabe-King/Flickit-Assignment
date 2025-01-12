import 'package:flutter/material.dart';
import 'package:frontend/screens/drill_details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List drills = [];

  @override
  void initState() {
    super.initState();
    fetchDrills();
  }

  Future<void> fetchDrills() async {
    const String apiUrl =
        "http://10.0.2.2:3000/api/drills"; // Replace with your server URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          drills = json.decode(response.body);
        });
        print(drills);
        print('---------------------------------------------');
      } else {
        throw Exception("Failed to load drills");
      }
    } catch (e) {
      print("Error fetching drills: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: drills.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: drills.length,
              itemBuilder: (context, index) {
                final drill = drills[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      drill['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(drill['name']),
                    subtitle: Text("Total Count: ${drill['total_count']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrillDetailScreen(
                            drill: drill,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
