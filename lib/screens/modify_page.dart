import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class modifyPage extends StatefulWidget {
  const modifyPage({Key? key}) : super(key: key);
  @override
  State<modifyPage> createState() => _modifyPageState();
}

class _modifyPageState extends State<modifyPage> {
  void chgPassword(String password) async{
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.updatePassword(password).then((_) {
        print('change success');
      }).catchError((error) {
        print('error occur');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보 수정'),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.check),
          )
        ],

      ),
    );
  }
}
