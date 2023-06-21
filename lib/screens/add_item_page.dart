import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/* 게시물 추가 페이지 */
class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key, required this.email, required this.uid, required this.num}) : super(key: key);
  final email;
  final uid;
  final num;
  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  List<String> dropList = [
    '디지털기기', '생활가전', '가구/인테리어', '생활/주방',
    '유아동', '유아도서', '여성의류', '여성잡화',
    '남성패션', '남성잡화', '뷰티/미용', '스포츠/레저',
    '취미/게임/음반', '도서', '티켓/교환권', '가공식품',
    '반려동물용품', '식물', '기타'];
  String selectedValue = '디지털기기';
  ImagePicker _picker = ImagePicker();
  DateTime dt = DateTime.now();
  late String user = widget.email.substring(0, widget.email.indexOf('@'));
  late String title;
  late String registerDate;
  late String detail;
  late String img = 'null';
  late String loc = '부평구 산곡동';
  late String idx = widget.uid;
  late String id = '';
  late int price;
  late int view_count;
  late int like_count;
  bool _isCheck = false;
  late File userImage;
  XFile? _pick;
  Future getImage() async {
    _pick = await _picker.pickImage(source: ImageSource.gallery);
    _isCheck = true;
    setState(() {
      userImage = File(_pick!.path);
    });
  }
  Future uploadImage() async {
    if (_pick != null) {
      Uint8List _bytes = await _pick!.readAsBytes();
      await FirebaseStorage.instance.ref('/image/${id}.jpg').putData(_bytes);
      img = (await FirebaseStorage.instance.ref('/image/${id}.jpg').getDownloadURL()).toString();
    }
  }

  Future <String> loadImage() async{
    //select the image url
    Reference ref = FirebaseStorage.instance.ref('/image/beta.jpg');
    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    print('url: ' + url);
    return url;
  }

  getRandom() {
    var _random = Random();
    var min = 0x61; //start ascii  사용할 아스키 문자의 시작
    var max = 0x7A; //end ascii    사용할 아스키 문자의 끝
    var dat = []; //비밀번호 저장용 리스트
    while (dat.length <= 16) {
      var tmp = min + _random.nextInt(max - min);
      dat.add(tmp);
    }
    return String.fromCharCodes(dat.cast<int>());
  }
  @override
  Widget build(BuildContext context) {
    registerDate = (dt.toString()).substring(0,19);
    id = getRandom();
    return Scaffold(
      appBar: AppBar(
        title: Text('판매글 등록'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              uploadImage().then((value) => {
                if (_isCheck == true) {
                  firestore.collection(widget.uid).add({
                    'detail': detail,
                    'idx': idx,
                    'img': img,
                    'like_count': 0,
                    'loc': loc,
                    'price': price,
                    'registerDate': registerDate,
                    'title': title,
                    'user': user,
                    'view_count': 0,
                    'id': id,
                    'type': selectedValue,
                  }
                  ),
                  firestore.collection('items').add({
                    'detail': detail,
                    'idx': idx,
                    'img': img,
                    'like_count': 0,
                    'loc': loc,
                    'price': price,
                    'registerDate': registerDate,
                    'title': title,
                    'user': user,
                    'view_count': 0,
                    'id': id,
                    'type': selectedValue,
                  }
                  ),
                  Navigator.pop(context),
                }
              });
            },
            child: Text(
              '등록',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: _pick == null ? AssetImage('images/empty_img.png') as ImageProvider : FileImage(userImage),
                        //image: _isCheck == true ? Image.file(File(_imageFile!.path)) as ImageProvider : AssetImage('images/empty_img.png') as ImageProvider,
                      )
                    ),
                    width: MediaQuery.of(context).size.width-30,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: InkWell(
                      onTap: () {
                        getImage();
                        },
                        child: _pick == null ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              '사진추가'
                            ),
                          ],
                        ) : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '제목',
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
              onChanged: (value) => title = value,
            ),
            const Divider(thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.5 - 20,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '￦ 가격',enabledBorder: InputBorder.none,
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
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    onChanged: (price_input) {
                      price = int.parse(price_input);
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                DropdownButton(
                    value: selectedValue,
                    items: dropList.map((String item) {
                      return DropdownMenuItem<String>(
                        child: Text('$item'),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      setState(() {
                        selectedValue = value;
                      });
                    }
                ),
              ],
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '게시물 내용을 작성해주세요.',enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303030)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303030)),
                ),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: null,
              style: TextStyle(
                fontSize: 16.0,
              ),
              onChanged: (detail_value) => detail = detail_value,
            ),
          ],
        ),
      ),
    );
  }
}

