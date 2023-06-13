import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/like_page.dart';
import '../screens/profile_page.dart';
import '../screens/search_page.dart';
import '../screens/item_detail_page.dart';
import '../model/provider_model.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key, required this.email, required this.uid}) : super(key: key);
  final email;
  final uid;
  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('판매글 등록'),
        actions: [
          TextButton(
            onPressed: () {  },
            child: Text(
              '등록',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 250,
                  height: 250,
                  color: Colors.redAccent.withOpacity(0.4),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '제목',
                enabledBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '분류',
                enabledBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '￦ 가격',
                enabledBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '게시물 내용을 작성해주세요.',
                enabledBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
