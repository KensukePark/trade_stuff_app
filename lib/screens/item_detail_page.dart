import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/model/like_model.dart';

/* 판매 게시물 상세 페이지 */
class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({Key? key, required this.item, required this.register_date, required this.email}) : super(key: key);
  final item;
  final register_date;
  final email;
  @override
  ItemDetailPageState createState() => ItemDetailPageState();
}

class ItemDetailPageState extends State<ItemDetailPage> {
  late String uid = '';
  late int like_temp = widget.item.like_count;
  late int view_temp = widget.item.view_count + 1;
  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final like_provider = Provider.of<LikeProvider>(context);
    final usercol = FirebaseFirestore.instance.collection("items").doc(widget.item.id);
    if (widget.item.user != (widget.email).substring(0, (widget.email).indexOf('@'))) {
      usercol.update({
        "view_count": view_temp,
      });
    }
    getUid();
    print(widget.item.idx);
    print(uid);
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
                        child: widget.item.img == 'null' ?
                        Image.asset(
                          'images/no_img.jpg', fit: BoxFit.fill
                        ) :
                        Image.network(widget.item.img, fit: BoxFit.fill)
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
                                Text(widget.item.user),
                                Text(widget.item.loc)
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
                          widget.item.title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.register_date,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          widget.item.detail,
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
                      format.format(widget.item.price) + '원',
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
                        if (widget.item.user == (widget.email).substring(0, (widget.email).indexOf('@'))) {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text('실패'),
                              content: Text('자신의 게시물은 관심목록에 추가할 수 없습니다.'),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text("확인"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],

                            );
                          });
                        }
                        else {
                          like_temp++;
                          usercol.update({
                            "like_count": like_temp,
                          });
                          like_provider.addItem(uid, widget.item);
                          final usercol_2 = FirebaseFirestore.instance.collection("likes").doc(uid);
                          usercol_2.update({
                            "like_count": like_temp,
                          });
                          final usercol_3 = FirebaseFirestore.instance.collection(widget.item.idx).where('id', isEqualTo: widget.item.id);
                          usercol_3.limit(1).get().then((value) {
                            value.docs[0].reference.update({
                              "like_count": like_temp,
                            });
                            print('update complete');
                          });
                          /*
                          .limit(1).get().then((QuerySnapshot val) {
                            val.docs[0].reference.update({
                              "like_count": like_temp,
                            });
                          });
                           */
                            print('여기' + '${like_temp}');
                        }
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