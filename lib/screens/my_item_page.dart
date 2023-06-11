import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/my_provider_model.dart';
import 'item_detail_page.dart';

class MyItemPage extends StatefulWidget {
  const MyItemPage({Key? key}) : super(key: key);

  @override
  _MyItemPageState createState() {
    return _MyItemPageState();
  }
}

class _MyItemPageState extends State<MyItemPage> {
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
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final myitemProvider = Provider.of<MyItemProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('내 물건'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: myitemProvider.fetch_MyItems(),
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
            if (myitemProvider.items.isEmpty) {
              return const Center(child: Text('등록된 물건이 없습니다.'));
            } else {
              return ListView.separated(
                  padding: const EdgeInsets.all(15),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  shrinkWrap: true,
                  itemCount: myitemProvider.items.length,
                  itemBuilder: (context, index) {
                    view_temp = myitemProvider.items[index].view_count;
                    if ((myitemProvider.items[index].registerDate).substring(0,10) != date_now) {
                      var register_year = int.parse((myitemProvider.items[index].registerDate).substring(0,4));
                      var register_mon = int.parse((myitemProvider.items[index].registerDate).substring(5,7));
                      var register_day = int.parse((myitemProvider.items[index].registerDate).substring(8,10));
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
                      register_print = (hour_now - int.parse(myitemProvider.items[index].registerDate.substring(11,13))).toString() + '시간 전';
                    }
                    return InkWell(
                      onTap: () {
                        final usercol = FirebaseFirestore.instance.collection("items").doc(myitemProvider.items[index].id);
                        usercol.get().then((value) => {
                          view_temp = (value.data()?['view_count'])
                        });
                        view_temp++;
                        usercol.update({
                          "view_count": view_temp,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ItemDetailPage(
                                item: myitemProvider.items[index],
                                register_date: register_print)
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
                                  child: Image.network(
                                    myitemProvider.items[index].img,
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
                                      myitemProvider.items[index].title,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 3.0,),
                                    Text(
                                      myitemProvider.items[index].loc + ' ' + register_print,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 3.0,),
                                    Text(
                                      format.format(myitemProvider.items[index].price) + '원',
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
                                              '${myitemProvider.items[index].like_count}',
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
    );
  }
}