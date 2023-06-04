import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/item_model.dart';

class ItemProvider with ChangeNotifier {
  late CollectionReference itemsReference;
  List<Item> items = [];
  List<Item> find_result = [];

  ItemProvider({reference}) {
    itemsReference = reference ?? FirebaseFirestore.instance.collection('items');
  }

  Future<void> fetch_Items() async {
    items = await itemsReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Item.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
  }

  Future<void> find_Item(String que) async {
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