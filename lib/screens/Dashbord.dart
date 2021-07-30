import 'package:barber/screens/navbarscreens/AppointmentScreen.dart';
import 'package:barber/screens/navbarscreens/NotificationScreen.dart';
import 'package:flutter/material.dart';
import 'navbarscreens/DiscoverScreen.dart';
import 'navbarscreens/MessagesScreen.dart';
import 'navbarscreens/profileScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final List<Widget> _children = [
    Discover(),
    Notifications(      
      getDateTime: '',
    ),
    Appointment(0),
    Messages(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications, color: Colors.black),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money, color: Colors.black),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message, color: Colors.black),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.black,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }
}
