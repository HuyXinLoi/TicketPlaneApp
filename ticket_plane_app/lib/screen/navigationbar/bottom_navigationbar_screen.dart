import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_plane_app/screen/home/home_screen.dart';
import 'package:ticket_plane_app/screen/search/search_screen.dart';
import 'package:ticket_plane_app/screen/ticket/ticket_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final appScreens = [
    HomeScreen(),
    // const SearchScreen(),
    // const TicketScreen(),
    const Center(child: Text("Profile"))
  ];

  //change our index for BottomNavBar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: const Color(0xFF526700),
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
              // activeIcon: Icon()
            ),
            BottomNavigationBarItem(
              label: "Search",
              icon: Icon(Icons.search),
              // activeIcon: Icon()
            ),
            BottomNavigationBarItem(
              label: "Tickets",
              icon: Icon(Icons.airplane_ticket),
              // activeIcon: Icon()
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person),
              // activeIcon: Icon()
            )
          ]),
    );
  }
}
