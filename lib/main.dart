
import 'package:flutter/material.dart';
import 'lotto_select_view.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp build.. reload..');
    return MaterialApp(
      home: Scaffold(
        body : new LottoSelectView(),
      ),
    );
  }
}
