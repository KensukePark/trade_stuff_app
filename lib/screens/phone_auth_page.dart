import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class phoneAuthPage extends StatefulWidget {
  const phoneAuthPage({Key? key, required this.email}) : super(key: key);
  final email;
  @override
  State<phoneAuthPage> createState() => _phoneAuthPage();
}

class _phoneAuthPage extends State<phoneAuthPage> {
  bool _authCheck = false;
  bool _sendCheck = false;
  bool _showCheckAuth = false;
  int _leftTime = 0;
  late String phoneNum = '';
  late String verifyCode = '';
  late String correctCode = '';
  late Timer _timer;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late PhoneAuthCredential phoneAuthCredential;
  void signFun(PhoneAuthCredential phoneAuthCredential) async {
    try {
      //final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      print(_auth.currentUser?.email);
      final authCredential = await _auth.currentUser?.linkWithCredential(phoneAuthCredential);
      if (authCredential != null) {
        setState(() {
          print('인증완료');
          _showCheckAuth = true;
          _leftTime = -999;
          _authCheck = true;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
            email: widget.email
        )));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        print('인증실패');
        _showCheckAuth = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('휴대전화 인증'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *0.7 - 15,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '휴대전화번호',
                          helperText: '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            phoneNum = value;
                          });
                        },
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        readOnly: _authCheck == true ? true : false,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (phoneNum == '' || _showCheckAuth == true) ? null : () async {
                        await _auth.verifyPhoneNumber(
                          timeout: const Duration(seconds: 120),
                          codeAutoRetrievalTimeout: (String verify_id) {
                            null;
                          },
                          phoneNumber: '+8210'+phoneNum.substring(3),
                          verificationCompleted: (phoneAuthCredential) async {

                          },
                          verificationFailed: (verifyFail) async {
                            print('인증번호 전송 실패');
                            print(verifyFail.code);
                          },
                          codeSent: (varify_id, send_idx) async {
                            setState(() {
                              correctCode = varify_id;
                            });
                            print('인증번호 전송 완료');
                            setState(() {
                              _sendCheck = true;
                              _leftTime = 120;
                            });
                            _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
                              setState(() {
                                if (_leftTime > 0) {
                                  _leftTime--;
                                }
                                else if (_leftTime <= 0) {
                                  _sendCheck = false;
                                  _timer.cancel();
                                }
                              });
                            });
                          },
                        );
                      },
                      child: Text('인증요청'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *0.7 - 10,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '인증번호',
                          helperText: '',
                        ),
                        onChanged: (value) {
                          verifyCode = value;
                        },
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        readOnly: (_authCheck == true || _sendCheck == false) ? true : false,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (_sendCheck == false || _showCheckAuth == true) ? null : () {
                        phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: correctCode, smsCode: verifyCode);
                        signFun(phoneAuthCredential);
                      },
                      child: _leftTime%60 >= 10 ?
                      Text('인증확인\n0${_leftTime~/60}:${_leftTime%60}', textAlign: TextAlign.center,) :
                      _leftTime <=0 ?
                      Text('인증확인', textAlign: TextAlign.center,) :
                      Text('인증확인\n0${_leftTime~/60}:0${_leftTime%60}', textAlign: TextAlign.center,)
                      ,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
