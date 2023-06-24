import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/screens/home_page.dart';
import 'package:shopping_app/screens/login_page.dart';

import '../model/like_model.dart';


/* 로그인시 사용할 로딩 페이지 */
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPage createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<LoadingPage> {
  Future<bool> checkLogin() async {
    final like_provider = Provider.of<LikeProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    String uid = prefs.getString('uid') ?? '';
    like_provider.fetchLikeItemsOrCreate(uid);
    return isLogin;
  }
  late Position position;
  Future<void> getPos() async{
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
  }
  Future<dynamic> getLoc() async {
    /*구글 맵 API 코드*/
    //String key = '***';
    //final url =
    //'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${key}&language=ko';
    //http.Response response = await http.get(Uri.parse(url));
    //return jsonDecode(response.body)['results'][0]['address_components'][1]['long_name'];
    /*카카오 API 코드*/
    String kakao_key = '5709c3ba2b2c84b9096249b89718bd47';
    final kakao_url =
        'https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=${position.longitude}&y=${position.latitude}';
    var headers = {'Authorization': 'KakaoAK ${kakao_key}'};
    http.Response respose_2 = await http.get(Uri.parse(kakao_url), headers: headers);
    return jsonDecode(respose_2.body)['documents'][0]['region_2depth_name'] + ' ' + jsonDecode(respose_2.body)['documents'][0]['region_3depth_name'];
  }
  void moveScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await checkLogin().then((isLogin) {
      if (isLogin) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(email: prefs.getString('email'))));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    getPos().then((value1) {
      getLoc().then((value2) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loca', value2);
        print(value2);
        moveScreen();
      });
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