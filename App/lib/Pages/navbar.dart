import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:transitway/Pages/route/homescreen.dart';
import 'package:transitway/Pages/profile/profilepage.dart';
import 'package:transitway/Pages/tickets/ticketspage.dart';

class NavBar extends StatefulWidget {
  final int pageIndex;
  const NavBar({
    required this.pageIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  final List<Widget> _screens = [
    const TicketsPage(),
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: GNav(
            padding: const EdgeInsets.all(15),
            backgroundColor: Colors.white.withOpacity(0),
            activeColor: Colors.white,
            textStyle: const TextStyle(
                fontFamily: 'UberMoveMedium', color: Colors.white),
            tabBackgroundColor: const Color.fromARGB(255, 81, 0, 204),
            tabs: const [
              GButton(
                icon: Icons.receipt_long,
                gap: 8,
                text: 'Bilete',
              ),
              GButton(
                icon: Icons.home_filled,
                gap: 8,
                text: 'Acasa',
              ),
              GButton(
                icon: Icons.person,
                gap: 8,
                text: 'Profil',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
