import 'package:flutter/material.dart';
import 'package:medileaf/screens/contact_us.dart';

import 'package:medileaf/screens/home.dart';
import 'package:medileaf/screens/identification.dart';
import 'package:medileaf/screens/profile.dart';
import 'package:medileaf/screens/species.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    Widget leadingWidget = Image.asset(
      'assets/images/logo.png',
      color: Colors.white,
    );
    var activePageTitle = 'Home';

    if (_selectedPageIndex == 1) {
      activePage = const SpeciesScreen();
      activePageTitle = 'Species';
    }

    if (_selectedPageIndex == 2) {
      activePage = const IdentificationScreen();
      activePageTitle = 'Identification';
    }
    if (_selectedPageIndex == 3) {
      activePage = const ContactUsScreen();
      activePageTitle = 'Contact us';
    }

    if (_selectedPageIndex == 4) {
      activePage = const ProfileScreen();
      activePageTitle = 'Profile';
      leadingWidget = const Icon(
        Icons.account_circle,
        size: 40,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        backgroundColor: const Color.fromRGBO(30, 156, 93, 1),
        leading: leadingWidget,
        titleSpacing: 5,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        elevation: 20,
        selectedFontSize: 12,
        selectedItemColor: const Color.fromRGBO(30, 156, 93, 1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), label: "Species"),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera), label: "Identification"),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups), label: "Contact us"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile")
        ],
      ),
    );
  }
}
