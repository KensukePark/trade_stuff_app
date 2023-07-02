import 'package:flutter/material.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);
  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('구매내역'),
      ),
    );
  }
}
