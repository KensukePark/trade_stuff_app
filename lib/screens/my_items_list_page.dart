import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/screens/profile_page.dart';
import 'item_detail_page.dart';

/* 내 게시물 상세 페이지 */
class MyItemsPage extends StatefulWidget {
  const MyItemsPage({Key? key, required this.myItem, required this.email}) : super(key: key);
  final myItem;
  final email;
  @override
  _MyItemsPageState createState() {
    return _MyItemsPageState();
  }
}

class _MyItemsPageState extends State<MyItemsPage> {
  int time = 0;
  var temp = '';
  var date_now;
  var year_now;
  var mon_now;
  var day_now;
  var time_now;
  late int hour_now;
  var register_print;
  late int view_temp;
  String uid = '';
  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  NumberFormat format = NumberFormat('#,###');
  Future<bool> onWillPop(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProfilePage(
      email: widget.email,
    )), (route) => false);
    return Future.value(false);
  }
  @override
  Widget build(BuildContext context) {
    getUid();
    return Scaffold(
      appBar: AppBar(
        title: Text('내 물건'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProfilePage(
              email: widget.email,
            )), (route) => false);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: widget.myItem.fetch_MyItems(),
            builder: (context, snapshots) {
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
              if (widget.myItem.items.isEmpty) {
                return const Center(child: Text('등록된 물건이 없습니다.'));
              } else {
                return ListView.separated(
                    padding: const EdgeInsets.all(15),
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    shrinkWrap: true,
                    itemCount: widget.myItem.items.length,
                    itemBuilder: (context, index) {
                      view_temp = widget.myItem.items[index].view_count;
                      if ((widget.myItem.items[index].registerDate).substring(0,10) != date_now) {
                        var register_year = int.parse((widget.myItem.items[index].registerDate).substring(0,4));
                        var register_mon = int.parse((widget.myItem.items[index].registerDate).substring(5,7));
                        var register_day = int.parse((widget.myItem.items[index].registerDate).substring(8,10));
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
                        if (hour_now - int.parse(widget.myItem.items[index].registerDate.substring(11,13)) > 0) {
                          register_print = (hour_now - int.parse(widget.myItem.items[index].registerDate.substring(11,13))).toString() + '시간 전';
                        }
                        else {
                          register_print = '방금 전';
                        }
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ItemDetailPage(
                                  item: widget.myItem.items[index],
                                  email: widget.email,)
                              )
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 5.0,),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.30,
                                    height: MediaQuery.of(context).size.width * 0.30,
                                    child: widget.myItem.items[index].img == 'null' ?
                                      Image(
                                        image: AssetImage('images/no_img.jpg'),
                                      ) :
                                      Image.network(
                                        widget.myItem.items[index].img,
                                        fit: BoxFit.fill,
                                      ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: MediaQuery.of(context).size.width * 0.30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.0,),
                                      Text(
                                        widget.myItem.items[index].title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 3.0,),
                                      Text(
                                        widget.myItem.items[index].loc + ' ' + register_print,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 3.0,),
                                      Text(
                                        format.format(widget.myItem.items[index].price) + '원',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                      children: [
                                        Container(height: MediaQuery.of(context).size.width * 0.3 - 24,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey,
                                              size: 24,
                                            ),
                                            Text(
                                                '${widget.myItem.items[index].like_count}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                )
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                            SizedBox(height: 5.0,),
                          ],
                        ),
                      );
                    }
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
