import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final String userId;
  const LeaderboardScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Leaderboard Data Here'),
      ),
    );
  }
}
