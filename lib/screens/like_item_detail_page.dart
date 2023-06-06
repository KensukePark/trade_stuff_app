import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/model/like_model.dart';

class LikeItemDetailPage extends StatefulWidget {
  const LikeItemDetailPage({Key? key,
    required this.item,
    required this.detail,
    required this.img,
    required this.loc,
    required this.title,
    required this.user,
    required this.like_count,
    required this.view_count,
    required this.price,
    required this.id,
    required this.register_date}) : super(key: key);
  final item;
  final detail;
  final img;
  final loc;
  final title;
  final user;
  final like_count;
  final view_count;
  final price;
  final id;
  final register_date;
  @override
  LikeItemDetailPageState createState() => LikeItemDetailPageState();
}

class LikeItemDetailPageState extends State<LikeItemDetailPage> {
  late String uid = '';
  late int like_temp = widget.like_count;
  late int view_temp = widget.view_count + 1;

  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final like_provider = Provider.of<LikeProvider>(context);

    final usercol = FirebaseFirestore.instance.collection("items").doc(widget.id);
    usercol.update({
      "view_count": view_temp,
    });
    getUid();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.network(widget.img, fit: BoxFit.fill)
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.lightBlue,
                              child: Icon(Icons.person, size: 36),
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.user),
                                Text(widget.loc)
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(
                          thickness: 1.0,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          widget.title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.register_date,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          widget.detail,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '관심 ${like_temp}· 조회${view_temp}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Divider(thickness: 1.0,),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      format.format(widget.price) + '원',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    like_provider.isItem(widget.item) ?
                    InkWell(
                      onTap: () {
                        like_temp--;
                        final usercol = FirebaseFirestore.instance.collection("items").doc(widget.item.id);
                        usercol.update({
                          "like_count": like_temp,
                        });
                        like_provider.removeItem(uid, widget.item);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    )
                        :
                    InkWell(
                      onTap: () {
                        like_temp++;
                        final usercol = FirebaseFirestore.instance.collection("items").doc(widget.item.id);
                        usercol.update({
                          "like_count": like_temp,
                        });
                        like_provider.addItem(uid, widget.item);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}