import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopping_app/screens/login_page.dart';
import 'package:shopping_app/screens/home_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPage createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<LoadingPage> {
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  void moveScreen() async {
    await checkLogin().then((isLogin) {
      if (isLogin) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2000), () {
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