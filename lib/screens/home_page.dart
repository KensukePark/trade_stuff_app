import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/like_page.dart';
import '../screens/profile_page.dart';
import '../screens/search_page.dart';
import '../screens/item_detail_page.dart';
import '../model/provider_model.dart';
import 'add_item_page.dart';

/* 모든 판매 게시물을 볼 수 있는 홈 페이지 */
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.email}) : super(key: key);
  final email;
  @override
  _HomePage createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  int _currentIndex = 0;
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
  late String uid = '';
  int num_item = 0;
  DateTime? currentBackPressTime;
  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  Future<bool> onWillPop(){
    DateTime now = DateTime.now();
    final msg = "'뒤로가기'버튼을 한 번 더 누르면 종료됩니다.";
    Fluttertoast.showToast(msg: msg);
    if(currentBackPressTime == null || now.difference(currentBackPressTime!)
        > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    getUid();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('중고거래'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 14),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 1 ? Icons.saved_search : Icons.search_outlined), label: '검색'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 2 ? Icons.favorite : Icons.favorite_border), label: '관심목록'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 3 ? Icons.person : Icons.person_outlined), label: '내 정보'),
        ],
        onTap: (int index){
          setState(() {
            _currentIndex = index;
            if(index == 1){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SearchPage(
                email: widget.email,
              )), (route) => false);
            }
            if(index == 2){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LikePage(
                email: widget.email,
              )), (route) => false);
            }
            if(index == 3){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProfilePage(
                email: widget.email,
              )), (route) => false);
            }
          });
        },
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: itemProvider.fetch_Items(),
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
              if (itemProvider.items.isEmpty) {
                return const Center(child: Text('등록된 물건이 없습니다.'));
              } else {
                return ListView.separated(
                    padding: const EdgeInsets.all(15),
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    shrinkWrap: true,
                    itemCount: itemProvider.items.length,
                    itemBuilder: (context, index) {
                      view_temp = itemProvider.items[index].view_count;
                      num_item = itemProvider.items.length;
                      //int like_temp = itemProvider.items[index].like_count;
                      if ((itemProvider.items[index].registerDate).substring(0,10) != date_now) {
                        //ex) 2023-06-04 substring5,7 => 월, 8,10 => 일
                        var register_year = int.parse((itemProvider.items[index].registerDate).substring(0,4));
                        var register_mon = int.parse((itemProvider.items[index].registerDate).substring(5,7));
                        var register_day = int.parse((itemProvider.items[index].registerDate).substring(8,10));
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
                        if (hour_now - int.parse(itemProvider.items[index].registerDate.substring(11,13)) > 0) {
                          register_print = (hour_now - int.parse(itemProvider.items[index].registerDate.substring(11,13))).toString() + '시간 전';
                        }
                        else {
                          register_print = '방금 전';
                        }
                      }
                      return InkWell(
                        onTap: () {
                          final usercol = FirebaseFirestore.instance.collection("items").doc(itemProvider.items[index].id);
                          usercol.get().then((value) => {
                            view_temp = (value.data()?['view_count'])
                          });
                          if (itemProvider.items[index].user != (widget.email).substring(0, (widget.email).indexOf('@'))) {
                            view_temp++;
                            usercol.update({
                              "view_count": view_temp,
                            });
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ItemDetailPage(
                                  item: itemProvider.items[index],
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
                                    child: itemProvider.items[index].img == 'null' ?
                                    Image.asset(
                                      'images/no_img.jpg', fit: BoxFit.fill
                                    ) :
                                    Image.network(
                                      itemProvider.items[index].img,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.0,),
                                      Text(
                                        itemProvider.items[index].title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3.0,),
                                      Text(
                                        itemProvider.items[index].loc + ' · ' + register_print,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 3.0,),
                                      Text(
                                        format.format(itemProvider.items[index].price) + '원',
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
                                            '${itemProvider.items[index].like_count}',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemPage(
            email: widget.email, uid: uid, num: num_item,
          )));
        },
        label: const Text(
            '글쓰기',
            style: TextStyle(
              color: Colors.white,
            )
        ),
        icon: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.pink,
      ),
    );
  }
}