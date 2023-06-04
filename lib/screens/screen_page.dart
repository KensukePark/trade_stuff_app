import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/cart_page.dart';
import '../screens/profile_page.dart';
import '../screens/search_page.dart';


class screenPage extends StatefulWidget {
  @override
  _screenPage createState() {
    return _screenPage();
  }
}

class _screenPage extends State<screenPage> {
  int _currentIndex = 0;
  final List<Widget> tabs = [
    HomePage(),
    SearchPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('산곡동'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 36,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 14),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 1 ? Icons.saved_search : Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 2 ? Icons.favorite : Icons.favorite_border), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 3 ? Icons.person : Icons.person_outlined), label: 'Profile'),
        ],
      ),
      body: tabs[_currentIndex],
    );
  }
}