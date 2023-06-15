import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isCheck = false;
  Future getImage(ImageSource source) async {
    final getFile = await _picker.pickImage(source: source);
    if (getFile != null) {
      setState(() {
        _imageFile = XFile(getFile.path);
        _isCheck = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('판매글 등록'),
        actions: [
          TextButton(
            onPressed: () {  },
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
                        image: _isCheck == true ? Image.file(File(_imageFile!.path)) as ImageProvider : AssetImage('images/empty_img.png') as ImageProvider,
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
                    keyboardType: TextInputType.number
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
            ),
          ],
        ),
      ),
    );
  }
}

