import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void chgPassword(String password) async{
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      //user.updatePhoneNumber(phoneCredential)
      user.updatePassword(password).then((_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('비밀번호 변경 완료')));
        
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('비밀번호 변경 실패')));
        Navigator.pop(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
