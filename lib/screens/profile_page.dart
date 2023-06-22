import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/screens/home_page.dart';
import 'package:shopping_app/screens/loading_provider.dart';
import 'package:shopping_app/screens/login_page.dart';
import 'package:shopping_app/screens/modify_page.dart';
import 'package:shopping_app/screens/search_page.dart';
import '../model/auth_model.dart';
import 'like_page.dart';

/* 프로필 페이지 */
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.email}) : super(key: key);
  final email;
  @override
  _ProfilePage createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage>{
  int _currentIndex = 3;
  String cur_pw = '';
  Future<void> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cur_pw = prefs.getString('uid') ?? '';
  }
  @override
  Widget build(BuildContext context) {
    getPassword();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('내 정보'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 14),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 1 ? Icons.saved_search : Icons.search_outlined), label: '검색'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 2 ? Icons.favorite : Icons.favorite_border), label: '관심목록'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 3 ? Icons.person : Icons.person_outlined), label: '내 정보'),
        ],
        onTap: (int index){
          setState(() {
            _currentIndex = index;
            if(index == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(
                email: widget.email,
              )));
            }
            if(index == 0){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
                email: widget.email,
              )));
            }
            if(index == 2){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LikePage(
                email: widget.email,
              )));
            }
          });
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.lightBlue,
                            child: Icon(Icons.person, size: 36),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      LoginOutButton(),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingProvider(email: widget.email,)));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 22,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '판매 내역',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'spoqa'
                          )
                        )
                      ],
                    )
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => modifyPage(cur_pw: cur_pw,)));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_sharp,
                            size: 22,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                              '개인정보 수정',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'spoqa'
                              )
                          )
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    return TextButton(
      onPressed: () async {
        await authClient.auth_logout();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('logout!')));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginPage()), (route) => false);
      },
      child: Text(
        '로그아웃',
        style: TextStyle(
          fontSize: 16
        ),
      )
    );
  }
}