import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String id;
  late String user;
  late String title;
  late String registerDate;
  late String detail;
  late String img;
  late String loc;
  late int price;

  Item({
    required this.id,
    required this.user,
    required this.title,
    required this.registerDate,
    required this.detail,
    required this.img,
    required this.loc,
    required this.price,
  });

  Item.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    title = data['title'];
    user = data['user'];
    registerDate = data['registerDate'];
    detail = data['detail'];
    img = data['img'];
    loc = data['loc'];
    price = data['price'];
  }
}
