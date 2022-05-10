import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghuraghuri/home.dart';
import 'package:ghuraghuri/plan.dart';
import 'package:ghuraghuri/profile.dart';
import 'package:ghuraghuri/search.dart';

import 'logout.dart';

class BackGroundPage extends StatefulWidget {
  const BackGroundPage({Key? key}) : super(key: key);

  @override
  _BackGroundPageState createState() => _BackGroundPageState();
}

class _BackGroundPageState extends State<BackGroundPage> {
  int currentindex=0;
  final screens = [
    Home(),
    Search(),
    Plan(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.black87,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        currentIndex: currentindex,
        onTap: (index) => setState(() {
          currentindex = index;
        }),
        items:  const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            //backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
            //backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: "Plan",
            //backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
            //backgroundColor: Colors.deepPurple,
          ),
        ],
      ),
    );


  }
}