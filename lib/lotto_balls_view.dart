import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'res.dart';


class LottoBalls extends StatefulWidget{
  final int nLottoNum;
  LottoBalls(this.nLottoNum){
  }
  @override
  LottoBallsState createState() {
    return LottoBallsState(nLottoNum);
  }
}

class LottoBallsState extends State<LottoBalls> {
  int nLottoNum;
  bool bIsCheck;
  String szCurPath;
  String szBallPath;
  String szBlackPath;
  Image img;
  GestureDetector gd;
  LottoBallsState(int nLottoNum){
    
    this.nLottoNum = nLottoNum;
    bIsCheck = true;
    szBallPath = sprintf('assets/images/ball_%d.jpg', [nLottoNum]);
    szBlackPath = 'assets/images/ball_false.jpg';
    selectImage();
  }

  void selectImage(){
    if(bIsCheck) 
      this.szCurPath = this.szBallPath;
    else 
      this.szCurPath = this.szBlackPath;
    this.img = Image.asset(szCurPath);
  }

    @override
  Widget build(BuildContext context) {
    print('LottoBallsState build.. reload..');
    return GestureDetector(
      child: img,
      onTapDown: (TapDownDetails details) { print('onTapDown..' + szBallPath );},
      onTapUp: (TapUpDetails details) { print('onTapUp..' + szBallPath);},
      onTap : (){
        print('onTap...setState?????????');
        setState(() {
          bIsCheck = !bIsCheck;
          var res = Resource();
          res.setIsWhite(this.nLottoNum, bIsCheck);
          selectImage();
        });
      }
    );
  }
}


class ResultLottoBallsState extends State<LottoBalls> {
  int nLottoNum;
  String szCurPath;
  String szBallPath;
  String szBlackPath;
  Image img;
  GestureDetector gd;
  ResultLottoBallsState(int nLottoNum){
    
    this.nLottoNum = nLottoNum;
    szBallPath = sprintf('assets/images/ball_%d.jpg', [nLottoNum]);
    selectImage();
  }

  void selectImage(){
    this.img = Image.asset(szBallPath);
  }

    @override
  Widget build(BuildContext context) {
    print('LottoBallsState build.. reload..');
    return GestureDetector(
      child: img,
    );
  }
}