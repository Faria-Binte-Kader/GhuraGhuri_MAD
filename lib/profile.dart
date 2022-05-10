import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghuraghuri/logout.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        child: Center(
          child: Container(
            height: 50,
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Colors.deepPurpleAccent,
              color: Colors.deepPurple,
              elevation: 8.0,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const Log_Out()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text('Log Out',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}