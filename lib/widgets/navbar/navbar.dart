import 'package:abdullah_diary/views/home_screen/home_screen.dart';
import 'package:abdullah_diary/views/settings_screen.dart'; // Create this if not already
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SettingsScreen(), // Add your Settings screen here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Container
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Settings Icon
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: _currentIndex == 1 ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),

                const SizedBox(width: 60), // Space for center button
              ],
            ),
          ),

          // Floating Home Icon in the center
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.yellow : Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

