import 'package:flutter/material.dart';
import 'proc_lotto_select.dart';
import 'lotto_balls_view.dart';
import 'package:sprintf/sprintf.dart';

class LottoResultView extends StatefulWidget{

  List<List<int>> results;

  LottoResultView(this.results){

  }

  @override
  LottoResultViewState createState() {
    return new LottoResultViewState(this.results);
  }
}

class LottoResultViewState extends State<LottoResultView> {
  List<List<int>> results;
  List<Widget> resultsBalls;
  LottoResultViewState(this.results){
    resultsBalls = new List<Widget>();
    
    for(int i = 0 ; i < results.length ; i++){
      List<Widget> balls = new List<Widget>();
      for(int j = 0 ; j < results[i].length ; j++){
        balls.add(
          Image.asset(sprintf('assets/images/ball_%d.jpg', [this.results[i][j]])),
        );
      }
      Widget widget = GridView.count(
        padding: const EdgeInsets.all(5.0),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 20.0,
        crossAxisCount: 6,
        // physics: ScrollPhysics(), // to disable GridView's scrolling
        shrinkWrap: true,
        children: balls,
      );
      resultsBalls.add(widget);
    }

  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: Center(
        child: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: resultsBalls + <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('돌아가기'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}
