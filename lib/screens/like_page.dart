import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/model/like_model.dart';
import 'package:shopping_app/screens/home_page.dart';
import 'package:shopping_app/screens/item_detail_page.dart';
import 'package:shopping_app/screens/like_item_detail_page.dart';
import 'package:shopping_app/screens/profile_page.dart';
import 'package:shopping_app/screens/search_page.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key, required this.email}) : super(key: key);
  final email;
  @override
  _LikePage createState() {
    return _LikePage();
  }
}

class _LikePage extends State<LikePage> {
  String uid = '';
  int _currentIndex = 2;
  int time = 0;
  var temp = '';
  var date_now;
  var year_now;
  var mon_now;
  var day_now;
  var time_now;
  late int hour_now;
  var register_print;
  late int like_temp;
  NumberFormat format = NumberFormat('#,###');
  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final like_provider = Provider.of<LikeProvider>(context);
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(
                email: widget.email,
              )));
            }
            if(index == 0){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
                email: widget.email,
              )));
            }
            if(index == 3){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(
                email: widget.email,
              )));
            }
          });
        },
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: like_provider.fetchLikeItemsOrCreate(uid),
          builder: (context, snapshot) {
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
            if (like_provider.like_list.isEmpty) {
              return const Center(child: Text('등록된 물건이 없습니다.'));
            }
            else {
              return ListView.separated(
                padding: const EdgeInsets.all(15),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                shrinkWrap: true,
                itemCount: like_provider.like_list.length,
                itemBuilder: (context, index) {
                  if ((like_provider.like_list[index].registerDate).substring(0,10) != date_now) {
                    //ex) 2023-06-04 substring5,7 => 월, 8,10 => 일
                    var register_year = int.parse((like_provider.like_list[index].registerDate).substring(0,4));
                    var register_mon = int.parse((like_provider.like_list[index].registerDate).substring(5,7));
                    var register_day = int.parse((like_provider.like_list[index].registerDate).substring(8,10));
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
                    register_print = (hour_now - int.parse(like_provider.like_list[index].registerDate.substring(11,13))).toString() + '시간 전';
                  }
                  return InkWell(
                    onTap: () {
                      var detail = '';
                      var img = '';
                      var loc = '';
                      var title = '';
                      var user = '';
                      var like_count = 0;
                      var view_count = 0;
                      var price = 0;
                      final like_provider = Provider.of<LikeProvider>(context, listen: false);
                      final usercol = FirebaseFirestore.instance.collection("items").doc(like_provider.like_list[index].id);
                      //print(widget.id);
                      usercol.get().then((value) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LikeItemDetailPage(
                              item: like_provider.like_list[index],
                              detail: (value['detail']),
                              img: (value['img']),
                              loc: (value['loc']),
                              title: (value['title']),
                              user: (value['user']),
                              like_count: (value['like_count']),
                              view_count: (value['view_count']),
                              price: (value['price']),
                              id: like_provider.like_list[index].id,
                              register_date: register_print))
                        ),
                      });
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
                                child: Image.network(
                                  like_provider.like_list[index].img,
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
                                    like_provider.like_list[index].title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 3.0,),
                                  Text(
                                    like_provider.like_list[index].loc + ' ' + register_print,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 3.0,),
                                  Text(
                                    format.format(like_provider.like_list[index].price) + '원',
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          final usercol = FirebaseFirestore.instance.collection("items").doc(like_provider.like_list[index].id);
                                          usercol.get().then((value) => {
                                            like_temp = (value.data()?['like_count'] - 1)
                                          });
                                          usercol.update({
                                            "like_count": like_temp,
                                          });
                                          like_provider.removeItem(uid, like_provider.like_list[index]);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.redAccent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.30 - 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                      Text(
                                          '${like_provider.like_list[index].like_count+1}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                      ],
                    ),
                  );
                },
              );
            }
          },
        )
      )
    );
  }
}