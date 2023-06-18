import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopping_app/screens/my_items_list_page.dart';
import '../model/like_model.dart';
import '../model/my_provider_model.dart';

/* 내가 올린 게시물들을 불러오기 위해 사용하는 페이지 */
class LoadingProvider extends StatefulWidget {
  const LoadingProvider({Key? key, required this.email}) : super(key: key);
  final email;
  @override
  _LoadingProvider createState() {
    return _LoadingProvider();
  }
}

class _LoadingProvider extends State<LoadingProvider> {
  void moveScreen() async {
    final myitemProvider = Provider.of<MyItemProvider>(context, listen: false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyItemsPage(myItem: myitemProvider, email: widget.email,)));
  }
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), () {
      moveScreen();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}