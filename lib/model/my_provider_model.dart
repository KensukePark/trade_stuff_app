import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/item_model.dart';

class MyItemProvider with ChangeNotifier {
  String uid = '';
  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('uid')!;
  }
  late CollectionReference itemsReference;
  List<Item> items = [];
  List<Item> find_result = [];

  MyItemProvider({reference}) {
    //uid = getUid();
    debugPrint('userId $uid');
    getUid().then((uid) {
      itemsReference = reference ?? FirebaseFirestore.instance.collection(uid);
    });
  }

  Future<void> fetch_MyItems() async {
    items = await itemsReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Item.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
  }

  Future<void> find_MyItem(String que) async {
    find_result = [];
    if (que.length == 0) return;
    for (Item item in items) {
      if (item.title.contains(que)) {
        find_result.add(item);
      }
      notifyListeners();
    }
  }
}