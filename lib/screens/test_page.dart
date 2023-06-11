import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/like_page.dart';
import '../screens/profile_page.dart';
import '../screens/search_page.dart';
import '../screens/item_detail_page.dart';
import '../model/provider_model.dart';

class testPage extends StatefulWidget {
  const testPage({Key? key}) : super(key: key);

  @override
  State<testPage> createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  late int _cnt = 0;
  var detail = '';
  var collection = FirebaseFirestore.instance.collection('items');
  _fun() async {
    var num = await collection.where("user", isEqualTo:"test").snapshots();
    setState(() {
      print(num);
    });
  }
  @override
  Widget build(BuildContext context) {
    _fun();
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(''),
          ],
        ),
      )
    );
  }
}
