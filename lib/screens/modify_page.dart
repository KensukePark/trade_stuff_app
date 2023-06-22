import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class modifyPage extends StatefulWidget {
  const modifyPage({Key? key, required this.cur_pw}) : super(key: key);
  final cur_pw;
  @override
  State<modifyPage> createState() => _modifyPageState();
}

class _modifyPageState extends State<modifyPage> {
  String new_ps = '';
  String new_ps_confirm = '';
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
              (new_ps != new_ps_confirm) ? showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Column(
                      children: [
                        Text('오류'),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '새 비밀번호와 비밀번호 확인이 일치하지 않습니다.'
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('확인'),
                      )
                    ],
                  );
                },
              ): null;
              //Navigator.pop(context);
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '새 비밀번호',
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303030)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303030)),
                ),
                errorText: new_ps != new_ps_confirm ? 'Password incorrect' : null,
              ),
              style: TextStyle(
                fontSize: 16.0,
              ),
              onChanged: (value) => new_ps = value,
              obscureText: true,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '새 비밀번호 확인',enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303030)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303030)),
                ),
              ),
              style: TextStyle(
                fontSize: 16.0,
              ),
              onChanged: (value) => new_ps_confirm = value,
              obscureText: true,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: (new_ps != new_ps_confirm) ? null : () {print('same');},
                child: Text('Regist'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}