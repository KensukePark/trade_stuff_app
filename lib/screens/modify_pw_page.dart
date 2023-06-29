import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class modifyPwPage extends StatefulWidget {
  const modifyPwPage({Key? key, required this.cur_pw}) : super(key: key);
  final cur_pw;
  @override
  State<modifyPwPage> createState() => _modifyPwPageState();
}

class _modifyPwPageState extends State<modifyPwPage> {
  String new_ps = '';
  String new_ps_confirm = '';
  String cur_pw_confirm = '';
  void chgPassword(String password) async{
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
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
    print(widget.cur_pw);
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.8 - 30,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '현재 비밀번호',
                      enabledBorder: InputBorder.none,
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
                    onChanged: (value) {
                      setState(() {
                        cur_pw_confirm = value;
                      });
                    },
                    obscureText: true,
                  ),
                ),
                widget.cur_pw == cur_pw_confirm ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.check, color: Colors.red,),
              ],
            ),
            const Divider(thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.8 - 30,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '새 비밀번호',
                      enabledBorder: InputBorder.none,
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
                    onChanged: (value) {
                      setState(() {
                        new_ps = value;
                      });
                    },
                    obscureText: true,
                  ),
                ),
                new_ps != '' ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.check, color: Colors.red,),
              ],
            ),
            const Divider(thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.8 - 30,
                  child: TextField(
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
                    onChanged: (value) {
                      setState(() {
                        new_ps_confirm = value;
                      });
                    },
                    obscureText: true,
                  ),
                ),
                new_ps == new_ps_confirm && new_ps_confirm != '' ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.check, color: Colors.red,),
              ],
            ),
            const Divider(thickness: 2,),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: (widget.cur_pw != cur_pw_confirm ||new_ps != new_ps_confirm || new_ps == '' || new_ps_confirm == '') ? null : () async {
                    chgPassword(new_ps);
                  },
                child: Text('Regist'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}