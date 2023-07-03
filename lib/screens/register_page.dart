import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/phone_auth_page.dart';
import '../model/auth_model.dart';
import '../model/register_model.dart';
import 'home_page.dart';

/* 회원가입 페이지 */
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPage createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  bool _idCheck = false;
  bool _emailCheck = false;
  String phoneNum = '';
  String verifyCode = '';
  String correctCode = '';
  String email = '';
  String ps = '';
  String ps_confirm = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  late PhoneAuthCredential phoneAuthCredential;
  DateTime? currentBackPressTime;
  void CheckSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          title: Column(
            children: <Widget>[
              new Text("중복확인"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "사용 가능한 이메일입니다.",
              ),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
  void CheckFail() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            title: Column(
              children: <Widget>[
                new Text("중복확인"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "사용할 수 없는 이메일입니다.",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
  Future<bool> onWillPop() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '회원가입을 취소하시겠습니까?',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              }, child: Text('네'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context,false);
              }, child: Text('아니요'),
            ),
          ],
        );
      }
    );
    /*
    DateTime now = DateTime.now();
    final msg = "뒤로가기 버튼을 한 번 더 누르면 회원가입을 종료합니다.";
    Fluttertoast.showToast(msg: msg);
    if(currentBackPressTime == null || now.difference(currentBackPressTime!)
        > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);

     */
  }
  @override
  Widget build(BuildContext context) {
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입'
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *0.7 - 10,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              _emailCheck = EmailValidator.validate(value);
                              _idCheck = false;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'email',
                            helperText: '',
                          ),
                        ),
                      ),
                      //EmailInput(),
                      //(_sendCheck == false || _showCheckAuth == true) ? null : () {
                      ElevatedButton(
                        onPressed: (email == '' || _emailCheck == false) ? null : () async {
                          int _Checking = 1;
                          var ps_temp = 'temp123';
                          try {
                            UserCredential userCre = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email, password: ps_temp);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              CheckFail();
                              setState(() {
                                _Checking = -1;
                              });
                            }
                          }
                          if (_Checking == 1) {
                            FirebaseAuth.instance.currentUser!.delete();
                            CheckSuccess();
                            _idCheck = true;
                          }
                        },
                        child: Text('중복확인'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        ps = value;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'password',
                      helperText: '',
                      errorText: ps != ps_confirm && ps != '' ? 'Password incorrect' : null,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        ps_confirm = value;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'password confirm',
                      helperText: '',
                    ),
                  ),
                ),
                //PasswordInput(),
                //PasswordConfirmInput(),
                /*
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *0.7 - 10,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: '휴대폰',
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
                _sendCheck == true ?
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
                          readOnly: _authCheck == true ? true : false,
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
                    : Container(),
                */
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: (
                        _idCheck == false || //중복확인을 하지 않았거나 중복된 아이디거나
                        email == '' || //이메일이 입력되지 않았거나
                        ps == '' ||  //패스워드가 입력되지 않았거나
                        ps != ps_confirm //패스워드 확인이 다르거나
                        //_authCheck == false //휴대폰 인증이 되지 않은 경우 회원가입 버튼 비활성화
                    ) ? null : () async {
                      await authClient
                          .auth_register(email, ps)
                          .then((registerStatus) {
                        if (registerStatus == AuthStatus.registerSuccess) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Regist Success')),
                            );
                          authClient.auth_login(
                            email, ps
                          ).then((loginStatus) {
                            if (loginStatus == AuthStatus.loginSuccess) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                    content:
                                    Text('welcome! ' + authClient.user!.email! + ' ')));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => phoneAuthPage(email: authClient.user!.email!)));
                              //_auth.currentUser!.linkWithCredential(phoneAuthCredential);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
                              //    email: authClient.user!.email!
                              //)));
                            } else {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text('login fail')));
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Regist Fail')),
                            );
                        }
                      });
                    },
                    child: Text('Regist'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width *0.7 - 10,
      child: TextField(
        onChanged: (email) {
          register.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'email',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (password) {
          register.setPassword(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password',
          helperText: '',
          errorText: register.password != register.passwordConfirm ? 'Password incorrect' : null,
        ),
      ),
    );
  }
}

class PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        onChanged: (password) {
          register.setPasswordConfirm(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password confirm',
          helperText: '',
        ),
      ),
    );
  }
}

class RegistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final register = Provider.of<RegisterModel>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: (register.password != register.passwordConfirm) ? null : () async {
          await authClient
              .auth_register(register.email, register.password)
              .then((registerStatus) {
            if (registerStatus == AuthStatus.registerSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('Regist Success')),
                );
              FirebaseFirestore.instance.collection(register.email).add({
                "key":null//your data which will be added to the collection and collection will be created after this
              });
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('Regist Fail')),
                );
            }
          });
        },
        child: Text('Regist'),
      ),
    );
  }
}