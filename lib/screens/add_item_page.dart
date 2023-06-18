import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key, required this.email, required this.uid}) : super(key: key);
  final email;
  final uid;
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
  XFile? _pick;
  ImagePicker _picker = ImagePicker();
  bool _isCheck = false;
  int _imageNum = 0;
  DateTime dt = DateTime.now();
  late String user = widget.email.substring(0, widget.email.indexOf('@'));
  late String title;
  late String registerDate;
  late String detail;
  late String img;
  late String loc = '부평구 산곡동';
  late String idx = widget.uid;
  late String id = '';
  late int price;
  late int view_count;
  late int like_count;
  Future getImage(ImageSource source) async {
    _pick = await _picker.pickImage(source: source);
  }
  Future uploadImage() async {
    if (_pick != null) {
      Uint8List _bytes = await _pick!.readAsBytes();
      FirebaseStorage.instance.ref('test2').putData(_bytes, SettableMetadata(contentType: 'image/jpeg',));
      setState(() {
        _isCheck = true;
      });
    }
  }
  getRandom() {
    var _random = Random();
    //무조건 들어갈 문자종류(문자,숫자,특수기호)의 위치를 기억할 리스트
    var leastCharacterIndex = [];
    var skipCharacter = [0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F, 0x60]; // 특수문자들 제거
    var min = 0x30; //start ascii  사용할 아스키 문자의 시작
    var max = 0x7A; //end ascii    사용할 아스키 문자의 끝
    var dat = []; //비밀번호 저장용 리스트
    while (dat.length <= 32) {
      var tmp = min + _random.nextInt(max - min);
      if (skipCharacter.contains(tmp)) {
        //print('skip ascii code $tmp.');
        continue;
      }
      //dat 리스트에 추가
      dat.add(tmp);
    }
    while(leastCharacterIndex.length < 3) {
      var ran = _random.nextInt(32);
      if(!leastCharacterIndex.contains(ran)) {
        leastCharacterIndex.add(ran);
      }
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
              uploadImage();
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              firestore.collection(widget.uid).add({
                'detail': detail,
                'idx': idx,
                'img': 'null',
                'like_count': 0,
                'loc': loc,
                'price': price,
                'registerDate': registerDate,
                'title': title,
                'user': user,
                'view_count': 0,
                'id': id,
                }
              );
              firestore.collection('items').add({
                'detail': detail,
                'idx': idx,
                'img': 'null',
                'like_count': 0,
                'loc': loc,
                'price': price,
                'registerDate': registerDate,
                'title': title,
                'user': user,
                'view_count': 0,
                'id': id,
                }
              );
              Navigator.pop(context);
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
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('images/empty_img.png') as ImageProvider,
                        //image: _isCheck == true ? Image.file(File(_imageFile!.path)) as ImageProvider : AssetImage('images/empty_img.png') as ImageProvider,
                      )
                    ),
                    width: MediaQuery.of(context).size.height * 0.15,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.gallery);
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
                        )
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
              ),
              style: TextStyle(
                fontSize: 16.0,
              ),
              onChanged: (value) => title = value,
            ),
            SizedBox(
              height: 5,
            ),
            const Divider(thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *0.5 - 20,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '￦ 가격',
                      enabledBorder: InputBorder.none,
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
            SizedBox(
              height: 5,
            ),
            const Divider(thickness: 2,),
            TextField(
              decoration: InputDecoration(
                hintText: '게시물 내용을 작성해주세요.',
                enabledBorder: InputBorder.none,
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

