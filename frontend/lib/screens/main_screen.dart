import 'package:flutter/material.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/leaderboard_screen.dart';

class MainScreen extends StatefulWidget {
  final String userId;

  const MainScreen({super.key, required this.userId});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(
        userId: widget.userId,
      ),
      DashboardScreen(
        userId: widget.userId,
      ),
      LeaderboardScreen(
        userId: widget.userId,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Flickit"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.exit_to_app))],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
      ),
    );
  }
}
