import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../model/auth_model.dart';
import '../model/register_model.dart';

/* 회원가입 페이지 */
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPage createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  bool _authCheck = false;
  bool _sendCheck = false;
  bool _showCheckAuth = false;
  late String phoneNum = '';
  late String verifyCode = '';
  late String correctCode = '';
  int _leftTime = 0;
  late Timer _timer;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void signFun(PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        setState(() {
          print('인증완료');
          _showCheckAuth = true;
          _leftTime = -999;
          _authCheck = true;
        });
        await _auth.currentUser!.delete();
        _auth.signOut();
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
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => RegisterModel(),
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  EmailInput(),
                  PasswordInput(),
                  PasswordConfirmInput(),
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
                            PhoneAuthCredential phoneAuthCredential =
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: (context.read<RegisterModel>().email == '' || //이메일이 입력되지 않았거나
                          context.read<RegisterModel>().password == '' ||  //패스워드가 입력되지 않았거나
                          context.read<RegisterModel>().password != context.read<RegisterModel>().passwordConfirm || //패스워드 확인이 다르거나
                          _authCheck == false //휴대폰 인증이 되지 않은 경우 회원가입 버튼 비활성화
                      ) ? null : () async {
                        await authClient
                            .auth_register(context.read<RegisterModel>().email, context.read<RegisterModel>().password)
                            .then((registerStatus) {
                          if (registerStatus == AuthStatus.registerSuccess) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(content: Text('Regist Success')),
                              );
                            FirebaseFirestore.instance.collection(context.read<RegisterModel>().email).add({
                              "key":null//your data which will be added to the collection and collection will be created after this
                            });
                            //var user_pro = FirebaseAuth.instance.
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
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(5),
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