import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ModelUser.dart';

Future<User?> createAccount(String name, String mail, String pass, String phone) async{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try{
    User? user = (await firebaseAuth.createUserWithEmailAndPassword(email: mail, password: pass)).user;
    if(user != null)
    { print("login successful");
    Fluttertoast.showToast(
        msg: "Signed up successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        fontSize: 16.0
    );
    return user;
    }
    else{
      print("login failed");
      return user;
    }
  }catch(e){
    print(e);
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        fontSize: 16.0
    );
    return null;
  }
}

Future<User?> logIn(String mail, String pass) async{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try{
    User? user = (await firebaseAuth.signInWithEmailAndPassword(email: mail, password: pass)).user;
    if(user != null)
    { print("login successful");
    Fluttertoast.showToast(
        msg: "Login Syccessful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
    return user;
    }
    else{
      print("login failed");
      return user;
    }
  }catch(e){
    print(e);
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        fontSize: 16.0
    );
    return null;
  }
}

Future logOut() async{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try{
    await firebaseAuth.signOut();
  }catch(e){
    print(e);
  }
}

Future<void> storeUserData(String name, String mail, String pass, String phone)async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid = firebaseAuth.currentUser!.uid.toString();
  users.add({
    'Name': name,
    'Uid': uid,
    'Phone': phone,
    'Mail': mail});
  return;
}

Future<void> storeArticle(String title, String desc, int like, int dislike, String url) async {
  CollectionReference article = FirebaseFirestore.instance.collection('Article');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid = firebaseAuth.currentUser!.uid.toString();
  DocumentReference docs= article.doc();
  article.add({
    'ID': docs.id,
    'Title': title,
    'Description': desc,
    'Uid': uid,
    'Url': url,
    'Like': like,
    'Dislike': dislike});
  return;
}

