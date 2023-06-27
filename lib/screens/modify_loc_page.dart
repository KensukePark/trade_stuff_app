import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class modifyLocPage extends StatefulWidget {
  const modifyLocPage({Key? key}) : super(key: key);
  @override
  State<modifyLocPage> createState() => _modifyLocPageState();
}

class _modifyLocPageState extends State<modifyLocPage> {
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
    String kakao_key = '***';
    final kakao_url =
        'https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=${position.longitude}&y=${position.latitude}';
    var headers = {'Authorization': 'KakaoAK ${kakao_key}'};
    http.Response respose_2 = await http.get(Uri.parse(kakao_url), headers: headers);
    return jsonDecode(respose_2.body)['documents'][0]['region_2depth_name'] + ' ' + jsonDecode(respose_2.body)['documents'][0]['region_3depth_name'];
  }
  @override
  void initState() {
    super.initState();
    getPos().then((value1) {
      getLoc().then((value2) async {
        print(value2);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loca', value2);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('현재 위치 업데이트 완료')));
        Navigator.pop(context);
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
