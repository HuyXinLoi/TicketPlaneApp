import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_plane_app/screen/home/home_screen.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_bloc.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_state.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';
import 'package:ticket_plane_app/screen/profile/profile_screen.dart';
import 'package:ticket_plane_app/screen/search/search_screen.dart';
import 'package:ticket_plane_app/screen/ticket/ticket_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final appScreens = [
          HomeScreen(),
          HomeScreen(),
          const Center(child: Text("Tickets")),
          state.status == LoginStates.success
              ? ProfileScreen(
                  userId: FirebaseAuth.instance.currentUser != null 
                      ? FirebaseAuth.instance.currentUser!.uid
                      : " ")
              : const LoginScreen(), 
        ];
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
              ),
              BottomNavigationBarItem(
                label: "Search",
                icon: Icon(Icons.search),
              ),
              BottomNavigationBarItem(
                label: "Tickets",
                icon: Icon(Icons.airplane_ticket),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(Icons.person),
              ),
            ],
          ),
        );
      },
    );
  }
}
