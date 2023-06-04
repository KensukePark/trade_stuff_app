import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/provider_model.dart';

class HomePage extends StatelessWidget{
  int time = 0;
  var temp = '';
  var date_now;
  var year_now;
  var mon_now;
  var day_now;
  var time_now;
  late int hour_now;
  var register_print;
  NumberFormat format = NumberFormat('#,###');
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    return SingleChildScrollView(
      child: FutureBuilder(
        future: itemProvider.fetchItems(),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
                padding: const EdgeInsets.all(15),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                shrinkWrap: true,
                itemCount: itemProvider.items.length,
                itemBuilder: (context, index) {
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
                    register_print = (hour_now - int.parse(itemProvider.items[index].registerDate.substring(11,13))).toString() + '시간 전';
                  }
                  return InkWell(
                    onTap: () {},
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
                                  Text(
                                    itemProvider.items[index].title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    itemProvider.items[index].loc + ' ' + register_print,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    format.format(itemProvider.items[index].price) + '원',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
                }
            );
          }
        },
      ),
    );
  }
}