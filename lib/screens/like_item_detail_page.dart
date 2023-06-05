import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/model/like_model.dart';

class LikeItemDetailPage extends StatefulWidget {
  const LikeItemDetailPage({Key? key, required this.item, required this.id, required this.register_date}) : super(key: key);
  final item;
  final id;
  final register_date;
  @override
  LikeItemDetailPageState createState() => LikeItemDetailPageState();
}

class LikeItemDetailPageState extends State<LikeItemDetailPage> {
  late String uid = '';
  late int like_temp = 0;
  var detail = ''; //a
  var img = ''; //b
  var loc = ''; //c
  var registerDate = ''; //d
  var title =''; //e
  var user = ''; //f
  var like_count = 0; //g
  var view_count = 0; //h
  var price = 0; //i
  void read_data(String a, String b, String c,String d, String e, String f, int g, int h, int i) async {
    final usercol = FirebaseFirestore.instance.collection('items').doc(widget.id);
    FirebaseFirestore.instance.collection('items').doc(widget.id).get().then((value) => {
      print(value.data()?['detail']),
      a = value.data()?['detail'],
      b = value.data()?['img'],
      c = value.data()?['loc'],
      d = value.data()?['registerDate'],
      e = value.data()?['title'],
      f = value.data()?['user'],
      g = value.data()?['like_count'],
      h = value.data()?['view_count'],
      i = value.data()?['price'],
    });

    print(a);
    //print(b);
    //print(c);
  }
  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final like_provider = Provider.of<LikeProvider>(context);
    final usercol = FirebaseFirestore.instance.collection("items").doc(widget.id);
    print(widget.id);
    usercol.get().then((value) => {
      //like_temp = (value['like_count']),
      detail = (value['detail']),
      img = (value['img']),
      loc = (value['loc']),
      registerDate = (value['registerDate']),
      title = (value['title']),
      user = (value['user']),
      like_count = (value['like_count']),
      view_count = (value['view_count']),
      price = (value['price']),
    });
    print(img);


    //read_data(detail, img, loc, registerDate, title, user, like_count, view_count, price);
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
                          child: Image.network(img, fit: BoxFit.fill)
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
                                Text(user),
                                Text(loc)
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
                          title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.register_date,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          detail,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '관심 ${like_count}· 조회${view_count}',
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
                      format.format(price) + '원',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),

                    like_provider.isItem(widget.item) ?
                    InkWell(
                      onTap: () {
                        like_temp = widget.item.like_count - 1;
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
                        like_temp = widget.item.like_count + 1;
                        usercol.update({
                          "like_count": like_temp,
                        });
                        like_provider.addItem(uid, widget.item);
                        final usercol_2 = FirebaseFirestore.instance.collection("like").doc(uid);
                        usercol_2.update({
                          "like_count": like_temp,
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
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