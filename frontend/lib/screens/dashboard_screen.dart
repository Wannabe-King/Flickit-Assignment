import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String userId;
  const DashboardScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('User Dashboard Data Here'),
      ),
    );
  }
}

