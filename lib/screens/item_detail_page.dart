import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/model/like_model.dart';

/* 판매 게시물 상세 페이지 */
class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({Key? key, required this.item, required this.email}) : super(key: key);
  final item;
  final email;
  @override
  ItemDetailPageState createState() => ItemDetailPageState();
}

enum Menu {
  change,
  delete,
}
class ItemDetailPageState extends State<ItemDetailPage> {
  List<String> dropList = [
    '판매중', '예약중', '판매완료'];
  late String uid = '';
  late int like_temp = widget.item.like_count;
  late int view_temp = widget.item.view_count + 1;
  int time = 0;
  var temp = '';
  var date_now;
  var year_now;
  var mon_now;
  var day_now;
  var time_now;
  late int hour_now;
  var register_print;
  String selectedValue = '판매중';
  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  showPopupMenue() {
    showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(25, 25, 0, 0),
        items: [
          PopupMenuItem<String>(
            child: Text('수정하기'), value: 'fir',
          ),
          PopupMenuItem<String>(
            child: Text('삭제하기'), value: 'sec',
          ),
        ]
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;
      if (itemSelected == 'fir') {
        print('수정하기');
      }
      else if (itemSelected == 'sec') {
        print('삭제하기');
      }
    });
  }
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final like_provider = Provider.of<LikeProvider>(context);
    final usercol = FirebaseFirestore.instance.collection("items").doc(widget.item.id);
    setState(() {
      selectedValue = widget.item.selling;
    });
    print(widget.item.idx);
    print(widget.item.id);
    print(widget.item.idd);

    if (widget.item.user != widget.email) {
      usercol.update({
        "view_count": view_temp,
      });
    }
    if (time == 0) {
      DateTime dt = DateTime.now();
      temp = dt.toString();
      date_now = temp.substring(0,10);
      year_now = int.parse(temp.substring(0,4));
      mon_now = int.parse(temp.substring(5,7));
      day_now = int.parse(temp.substring(8,10));
      time_now = temp.substring(11,19); //19까지 초시간
      hour_now = int.parse(temp.substring(11,13));
      time = 1;
    }
    if ((widget.item.registerDate).substring(0,10) != date_now) {
      //ex) 2023-06-04 substring5,7 => 월, 8,10 => 일
      var register_year = int.parse((widget.item.registerDate).substring(0,4));
      var register_mon = int.parse((widget.item.registerDate).substring(5,7));
      var register_day = int.parse((widget.item.registerDate).substring(8,10));
      if (register_year == year_now) {
        if (register_mon == mon_now) {
          register_print = (day_now - register_day).toString() + '일 전';
        }
        else {
          register_print = (mon_now - register_mon).toString() + '개월 전';
        }
      }
      else {
        register_print = (year_now - register_year).toString() + '년 전';
      }
    }
    else {
      if (hour_now - int.parse(widget.item.registerDate.substring(11,13)) > 0) {
        register_print = (hour_now - int.parse(widget.item.registerDate.substring(11,13))).toString() + '시간 전';
      }
      else {
        register_print = '방금 전';
      }
    }
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
                      (widget.item.user == widget.email) ?
                        Positioned(
                          right: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              showPopupMenue();
                            },
                            icon: Icon(Icons.more_horiz, color: Colors.white, size: 32),
                          ),
                        ) :
                          Text(''),


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
                                Text(widget.item.user.substring(0, widget.item.user.indexOf('@'))),
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
                        SizedBox(height: 2,),
                        Text(
                          '- '+ widget.item.type + '·' + register_print,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 2,),
                        Text(
                          '- '+ widget.item.state,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          widget.item.detail,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          '관심 ${like_temp} · 조회${view_temp}',
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
                    Row(
                      children: [
                        like_provider.isItem(widget.item) ?
                        InkWell(
                          onTap: () {
                            like_temp--;
                            final usercol = FirebaseFirestore.instance.collection("items").doc(widget.item.id);
                            usercol.update({
                              "like_count": like_temp,
                            });
                            final usercol_3 = FirebaseFirestore.instance.collection(widget.item.idx).where('idd', isEqualTo: widget.item.idd);
                            usercol_3.limit(1).get().then((value) {
                              value.docs[0].reference.update({
                                "like_count": like_temp,
                              });
                              print('update complete');
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
                            if (widget.item.user == widget.email) {
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
                              final usercol_3 = FirebaseFirestore.instance.collection(widget.item.idx).where('idd', isEqualTo: widget.item.idd);
                              usercol_3.limit(1).get().then((value) {
                                value.docs[0].reference.update({
                                  "like_count": like_temp,
                                });
                                print('update complete');
                              });
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
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            thickness: 1,
                            width: 20,
                          ),
                        ),
                        Text(
                          format.format(widget.item.price) + '원',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ],
                    ),
                    (widget.item.user != widget.email) ?
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue
                        ),
                        child: Text(
                          '구매하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                    : DropdownButton(
                        value: selectedValue,
                        items: dropList.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            selectedValue = value;
                          });
                          usercol.update({
                            "selling": value,
                          });
                          final usercol_3 = FirebaseFirestore.instance.collection(widget.item.idx).where('idd', isEqualTo: widget.item.idd);
                          usercol_3.limit(1).get().then((val) {
                            val.docs[0].reference.update({
                              "selling": value.toString(),
                            });
                            print('update complete2');
                          });
                        }
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