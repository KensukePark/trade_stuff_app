import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/like_page.dart';
import '../screens/profile_page.dart';
import '../screens/search_page.dart';
import '../screens/item_detail_page.dart';
import '../model/provider_model.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key, required this.email, required this.uid}) : super(key: key);
  final email;
  final uid;
  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
