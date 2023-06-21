import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopping_app/screens/home_page.dart';

class loading_upload extends StatefulWidget {
  const loading_upload({Key? key,
    required this.email,
    required this.uid,
    required this.detail,
    required this.idx,
    required this.img,
    required this.loc,
    required this.price,
    required this.registerDate,
    required this.title,
    required this.user,
    required this.id,
    required this.isCheck,}) : super(key: key);
  final email;
  final uid;
  final detail;
  final idx;
  final img;
  final loc;
  final price;
  final registerDate;
  final title;
  final user;
  final id;
  final isCheck;
  @override
  State<loading_upload> createState() => _loading_uploadState();
}

class _loading_uploadState extends State<loading_upload> {
  String new_img = '';
  void moveScreen() async {
    if (widget.isCheck == true) {
      Reference ref = FirebaseStorage.instance.ref('/image/${widget.id}.jpg');
      var url = await ref.getDownloadURL();
      new_img = url;
    }
    else {
      new_img = 'null';
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection(widget.uid).add({
      'detail': widget.detail,
      'idx': widget.idx,
      'img': new_img,
      'like_count': 0,
      'loc': widget.loc,
      'price': widget.price,
      'registerDate': widget.registerDate,
      'title': widget.title,
      'user': widget.user,
      'view_count': 0,
      'id': widget.id,
    }
    );
    firestore.collection('items').add({
      'detail': widget.detail,
      'idx': widget.idx,
      'img': new_img,
      'like_count': 0,
      'loc': widget.loc,
      'price': widget.price,
      'registerDate': widget.registerDate,
      'title': widget.title,
      'user': widget.user,
      'view_count': 0,
      'id': widget.id,
    }
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(email: widget.email,)));
  }
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), () {
      moveScreen();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
