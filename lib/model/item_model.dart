import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  late String id;
  late String user;
  late String title;
  late String registerDate;
  late String detail;
  late String img;
  late String loc;
  late String idx;
  late String type;
  late int price;
  late int view_count;
  late int like_count;
  late String state;
  late String selling;
  late String idd;
  late String phone;

  Item({
    required this.id,
    required this.user,
    required this.title,
    required this.registerDate,
    required this.detail,
    required this.img,
    required this.loc,
    required this.idx,
    required this.type,
    required this.price,
    required this.view_count,
    required this.like_count,
    required this.state,
    required this.selling,
    required this.idd,
    required this.phone,
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
    idx = data['idx'];
    type = data['type'];
    price = data['price'];
    view_count = data['view_count'];
    like_count = data['like_count'];
    state = data['state'];
    selling = data['selling'];
    idd = data['idd'];
    phone = data['phone'];
  }

  Item.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    user = data['user'];
    registerDate = data['registerDate'];
    detail = data['detail'];
    img = data['img'];
    loc = data['loc'];
    idx = data['idx'];
    type = data['type'];
    price = data['price'];
    view_count = data['view_count'];
    like_count = data['like_count'];
    state = data['state'];
    selling = data['selling'];
    idd = data['idd'];
    phone = data['phone'];
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'id': id,
      'title': title,
      'user': user,
      'registerDate':registerDate,
      'detail': detail,
      'img':img,
      'loc':loc,
      'idx':idx,
      'type':type,
      'price':price,
      'view_count':view_count,
      'like_count':like_count,
      'state':state,
      'selling':selling,
      'idd':idd,
      'phone':phone,
    };
  }

}
