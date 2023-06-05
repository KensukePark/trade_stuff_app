import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/item_model.dart';

class LikeProvider with ChangeNotifier {
  late CollectionReference _reference;
  List<Item> like_list = [];

  LikeProvider({reference}) {
    _reference = reference ?? FirebaseFirestore.instance.collection('likes');
  }

  Future<void> fetchLikeItemsOrCreate(String uid) async {
    if (uid == ''){
      return ;
    }
    final like_snapshot = await _reference.doc(uid).get();
    if(like_snapshot.exists) {
      Map<String, dynamic> like_Map = like_snapshot.data() as Map<String, dynamic>;
      List<Item> temp = [];
      for (var item in like_Map['items']) {
        temp.add(Item.fromMap(item));
      }
      like_list = temp;
      notifyListeners();
    } else {
      await _reference.doc(uid).set({'items': []});
      notifyListeners();
    }
  }

  Future<void> addItem(String uid, Item item) async {
    like_list.add(item);
    Map<String, dynamic> LikedItemsMap = {
      'items': like_list.map((item) {
        return item.toSnapshot();
      }).toList()
    };
    await _reference.doc(uid).set(LikedItemsMap);
    notifyListeners();
  }

  Future<void> removeItem(String uid, Item item) async {
    like_list.removeWhere((element) => element.id == item.id);
    Map<String, dynamic> LikedItemsMap = {
      'items': like_list.map((item) {
        return item.toSnapshot();
      }).toList()
    };

    await _reference.doc(uid).set(LikedItemsMap);
    notifyListeners();
  }

  bool isItem(Item item) {
    return like_list.any((element) => element.id == item.id);
  }
}