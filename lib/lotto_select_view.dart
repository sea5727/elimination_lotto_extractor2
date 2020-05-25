import 'package:elimination_lotto_extractor2/res.dart';
import 'package:flutter/material.dart';
import 'lotto_result_view.dart';
import 'lotto_balls_view.dart';
import 'lotto_statistics_view.dart';
import 'proc_lotto_select.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';


class LottoSelectView extends StatefulWidget{
  @override
  LottoSelectViewState createState() {
    return new LottoSelectViewState();
  }
}

class LottoSelectViewState extends State<LottoSelectView> {
  var textControl = TextEditingController();
  List<LottoBalls> lottoBallsList = new List<LottoBalls>(45);

  GestureDetector gd;
  LottoSelectViewState(){
    for(int i = 0 ; i < lottoBallsList.length; i++){
      lottoBallsList[i] = new LottoBalls(i + 1);
    }
    textControl.text = '5';
  }
  @override
  void dispose(){
    textControl.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    textControl.addListener(printCountValue);
  }
  printCountValue(){
    try{
      if(int.parse(textControl.text) > 10){
        textControl.text = '10';
      }
      else {

      }
        // prevCount = textControl.text;
    }
    catch(err){
    }
  }

  Widget makeDraw(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child : Text(''),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title : Text('앱 설명서'),
            onTap: (){
            },
          ),
          ListTile(
            title : Text('통계 조회'),
            onTap: (){
              Navigator.push( 
                context, 
                new MaterialPageRoute(builder: (context) => new LottoStatisticsView()),
                ).then((value) {
                  setState(() {
                    
                });
              });
            },
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    print('LottoSelectViewState build.. reload..');
    return Scaffold(
      appBar: AppBar(
        title : Text('제거할 번호를 선택 후 추첨하세요'),
      ),
      drawer: makeDraw(),
      body : Padding(
          padding: EdgeInsets.all(20.0),
          child:         ListView(
        children: <Widget>[
          GridView.count(
            padding: const EdgeInsets.all(5.0),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 40.0,
            crossAxisCount: 5,
            // physics: ScrollPhysics(), // to disable GridView's scrolling
            shrinkWrap: true,
            children: lottoBallsList,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('갯수'),
                Container(
                  width: 50,
                  child: TextFormField(
                    controller: textControl,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text('추첨'),
                  onPressed: () {
                    List<List<int>> results = List<List<int>>();
                    var res = Resource();
                    var blacklist = res.getIsWhite();
                    int whilecount = 0;

                    try{
                      blacklist.forEach((element) {
                        if(element) whilecount+=1 ;
                      });
                      if(whilecount < 6) 
                        throw Exception('less 6');
                      int count = int.parse(textControl.text);
                      for(int i = 0 ; i < count ; i++){
                        var aver = [22.2, 22.2, 22.2, 22.2, 11.1];
                        var pls = ProcLottoStatistics(blacklist, aver);
                        var result = pls.procSelectLotto();
                        results.add(result);
                      }
                      print('count is ' + count.toString());
                    }
                    catch(e){
                      print(e);

                    }
                    finally{
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) =>  LottoResultView(results))
                      );
                    }

                  },
                ),
              ],
            ),
          ),
        ],
      ),
        ),
    );
  }
}