import 'package:flutter/material.dart';
import 'package:tango_admin/screens/allMenuScreen.dart';
import 'package:tango_admin/screens/home_screen.dart';
import 'package:tango_admin/screens/upload_screen.dart';

var width;
var height;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MenuScreen(),
    UploadDish(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffa6148f),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.lunch_dining,
              size: width * .09,
            ),
            icon: Icon(Icons.lunch_dining_outlined),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.menu_book,
              size: width * .09,
            ),
            icon: Icon(Icons.menu_book_rounded),
            label: 'DISHES',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.upload,
              size: width * .09,
            ),
            label: 'Upload',
            icon: Icon(Icons.upload),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
