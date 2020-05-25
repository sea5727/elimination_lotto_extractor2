import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'number_picker.dart';
import 'package:sprintf/sprintf.dart';
import 'file_manage.dart';
import 'res.dart';

class  LottoSections{
  String domain;
  double average;
  Color colorval;
  LottoSections(this.domain, this.average, this.colorval);
}


class LottoStatisticsView extends StatefulWidget{
  @override
  LottoStatisticsViewState createState() {
    return new LottoStatisticsViewState();
  }
}

class LottoStatisticsViewState extends State<LottoStatisticsView> {

  static const int MIN_STAGE = 1;
  static const int MAX_STAGE = 943;
  int min_stage = 908;
  int max_stage = 908;

  Stream<List<charts.Series<LottoSections, String>>> pieStreams;
  List<Map<String, dynamic>> lottoInfo;


  List<charts.Series<LottoSections, String>> _seriesPieData;
  LottoStatisticsViewState(){
    _seriesPieData = List<charts.Series<LottoSections, String>>();

    var pieData = [
      new LottoSections('1~10번', 35.8, Color(0xff1c39bb)),
      new LottoSections('11~20번', 8.3, Color(0xffe52b50)),
      new LottoSections('21~31번', 10.8, Color(0xff00ff7f)),
      new LottoSections('31~41번', 15.6, Color(0xfffdee00)),
      new LottoSections('41~45번', 19.2, Color(0xffffae42)),
    ];
    _seriesPieData.add(
      charts.Series(
        data:pieData,
        domainFn: (LottoSections task, _) => task.domain,
        measureFn: (LottoSections task, _) => task.average,
        colorFn: (LottoSections task, _) => charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Daily Task',
        labelAccessorFn: (LottoSections row, _) => '${row.average}',
      )
    );
  }
  Row makeButtonOfSection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('회차 : '),
        RaisedButton(
          child : Text('${this.min_stage}'),
          onPressed: () {
            showDialogNumberPicker(
              context, 
              MIN_STAGE, 
              MAX_STAGE, 
              this.min_stage, 
              (value){
                setState((){
                  this.min_stage = value;
                });
              });
          },
        ),
        Text('~'),
        RaisedButton(
          child: Text('${this.max_stage}'),
          onPressed: (){
            showDialogNumberPicker(
              context, 
              MIN_STAGE, 
              MAX_STAGE, 
              this.max_stage,
              (value) {
                setState((){
                  this.max_stage = value;
                });
              });
          },
        )
      ],
    );
  }
  Widget makeTable(){

    var rows = List<DataRow>();

    var res = Resource();
    lottoInfo.forEach((element){
      rows.add(DataRow( 
        cells: [
          DataCell(
            // Text('test'),
            Container(
              width: 25,
              child : Text(element['drwNo'].toString())
            )
          ),
          DataCell( 
            // Text('test'),
            Container(
              width: 120,
              child : Row(
                children: <Widget>[
                  res.getImage(sprintf('smallball_%d', [element['drwtNo1']])),
                  res.getImage(sprintf('smallball_%d', [element['drwtNo2']])),
                  res.getImage(sprintf('smallball_%d', [element['drwtNo3']])),
                  res.getImage(sprintf('smallball_%d', [element['drwtNo4']])),
                  res.getImage(sprintf('smallball_%d', [element['drwtNo5']])),
                  res.getImage(sprintf('smallball_%d', [element['drwtNo6']])),
                ],
              ),
            ),
          ),
          DataCell(
            // Text('test'),
            Container(
              width : 20,
              child : res.getImage(sprintf('smallball_%d', [element['bnusNo']])),
            ),
          ),
          DataCell(
            // Text('test'),
            Container(
              child: Text(element['drwNoDate'].toString()),
            )
          ),
        ]
      ));
    }); 

    var columns = [
      DataColumn(
        onSort: (int columnIndex, bool ascending){
          if (columnIndex == 0) {
            if (ascending) {
              // lottoInfo.sort((a, b){
              //   return -(a['drwNo'] - b['drwNo']);
              // });
              // print('sort ascending end?');
            } else {
              // lottoInfo.sort((a, b){
              //   return -(a['drwNo'] - b['drwNo']);
              // });
              // print('sort decending end?');
            }
          }
        },
        label : Text('회차')
      ),
      DataColumn(label : Text('당첨번호')),
      DataColumn(label : Text('보너스')),
      DataColumn(label : Text('당첨일자')),
    ];

    return Container(
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child : DataTable(
              sortColumnIndex: 1,
              sortAscending: true,
              // columnSpacing  :5,
              // dataRowHeight: ,
              // horizontalMargin : 0,
              dividerThickness : 2,
              columns: columns,
              rows : rows,
            ),
          ),
        ),
      );


    // return DataTable(
    //       sortColumnIndex: 1,
    //       sortAscending: true,
    //       // columnSpacing  :5,
    //       // dataRowHeight: ,
    //       // horizontalMargin : 0,
    //       // dividerThickness : 2,
    //       columns: columns,
    //       rows : rows,
    //     );
  }

  Stream<List<charts.Series<LottoSections, String>>> makeStream(){
    return (() async* {
        List<charts.Series<LottoSections, String>> pie = List<charts.Series<LottoSections, String>>();
        lottoInfo = new List<Map<String, dynamic>>();
        var sumStatistics = List<int>.filled(46, 0);
        int total = 0;
        for(int i = min_stage; i <= this.max_stage; i++){
          var path = sprintf('assets/res/history_%d.txt', [i]);
          var data = await rootBundle.loadString(path);      
          Map<String, dynamic> obj = jsonDecode(data);
          print(obj['drwNo']);
          sumStatistics[obj['drwtNo1']] += 1;
          sumStatistics[obj['drwtNo2']] += 1;
          sumStatistics[obj['drwtNo3']] += 1;
          sumStatistics[obj['drwtNo4']] += 1;
          sumStatistics[obj['drwtNo5']] += 1;
          sumStatistics[obj['drwtNo6']] += 1;
          total += 6;
          lottoInfo.add(obj);
        }
        // makeTable();
       

        var colors = [
          Color(0xfff6cd61), 
          Color(0xff4169e1), 
          Color(0xffe52b50), 
          Color(0xff254855),
          Color(0xff00ff7f)];
        var idx = 0;
        var curNum = 1;
        var result = List<LottoSections>();
        var div = 0.0;
        sumStatistics.asMap().forEach((key, value) {
          div += (value.toDouble() / total) * 100;
          if([10, 20, 30, 40, 45].contains(key)){
            var v = double.parse(div.toStringAsPrecision(3));
            var prevNum = curNum + 1;
            curNum = key;
            result.add(
              new LottoSections('$prevNum번~$curNum번', v, colors[idx])
            );
            idx += 1;
            div = 0.0;
          }
        });
        // await Future<void>.delayed(Duration(seconds: 5));
        pie.add(
          charts.Series(
            data:result,
            domainFn: (LottoSections task, _) => task.domain,
            measureFn: (LottoSections task, _) => task.average,
            colorFn: (LottoSections task, _) => charts.ColorUtil.fromDartColor(task.colorval),
            id: 'Daily Task',
            labelAccessorFn: (LottoSections row, _) => '${row.average}',
          )
        );
        yield pie;
    })();
  }


  void readFile() async {
    print('start readAssets');
    for(int i = 0 ; i < 700 ; i++){
      var path = 'assets/res/history_1.txt'; 
      var data = await rootBundle.loadString(path);      
      // print(data);
    }
    print('end readAssets');
  }
  @override
  Widget build(BuildContext context) {
    print('start build');
    pieStreams = makeStream();
    print('start return Scaffold');
    return Scaffold(
      resizeToAvoidBottomPadding : false,
      appBar: AppBar(
        title : Text('역대 당첨번호 확률을 조회'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        // child : Container(
          child: Center(
            child : StreamBuilder<List<charts.Series<LottoSections, String>>>(
              stream : pieStreams,
              builder: (context, snapshot){
                var children = <Widget>[];
                if(snapshot.hasError){
                  children = <Widget>[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                }
                else {  
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                      children = <Widget>[
                        Text('ConnectionState.none')
                      ];
                      break;
                    case ConnectionState.waiting:
                      children = <Widget>[
                        Text('로딩중...')
                      ];
                      break;
                    case ConnectionState.active:
                      children = <Widget>[
                        Text('ConnectionState.active')
                      ];
                      break;
                    case ConnectionState.done:
                      children = <Widget>[
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child : Text('$min_stage ~ $max_stage 구역별 통계', style : TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),

                        ),
                        Expanded(
                          flex: 15,
                          child : Container(
                            width : double.infinity,
                            // height : 200,
                            child : charts.PieChart(
                              snapshot.data,
                              animate: true,
                              animationDuration: Duration(milliseconds: 500),
                              layoutConfig : charts.LayoutConfig(
                                leftMarginSpec : charts.MarginSpec.fixedPixel(10),
                                topMarginSpec : charts.MarginSpec.fixedPixel(10),
                                bottomMarginSpec : charts.MarginSpec.fixedPixel(10),
                                rightMarginSpec : charts.MarginSpec.fixedPixel(10),
                              ),

                              behaviors: [
                                new charts.DatumLegend
                                (
                                  position: charts.BehaviorPosition.end, 
                                  outsideJustification: charts.OutsideJustification.middleDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxColumns: 2,
                                  showMeasures: true,
                                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color : charts.MaterialPalette.blue.shadeDefault,
                                      fontFamily: 'Gerogia',
                                      fontSize: 13
                                  ),
                                ),
                              ],
                              defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator( 
                                    labelPosition: charts.ArcLabelPosition.inside
                                  )
                                ]
                              ),
                            )
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child : makeButtonOfSection(),
                        ),
                        Expanded(
                          flex: 10,
                          child : makeTable(),
                        )
                      ];
                      break;
                  }
                }
                // return Container(
                //   width : double.infinity,
                //   height : 300,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: children,
                //   )
                // );
                return Column(
                  children: children,
                );
              }
            ),
          ),
        // ),
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(8.0),
      //   child: Container(
      //     child: Center(
      //       child: Column(
      //         children: <Widget>[
      //           Text('$min_stage ~ $max_stage 구역별 통계', style : TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      //           Container(
      //             width: double.infinity,
      //             height: 300,
      //             child: StreamBuilder<List<charts.Series<LottoSections, String>>>(
      //               stream : pieStreams,
      //               builder: (context, snapshot){

      //                 List<Widget> children;
      //                 if(snapshot.hasError){
      //                   children = <Widget>[
      //                     Icon(
      //                       Icons.error_outline,
      //                       color: Colors.red,
      //                       size: 60,
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.only(top: 16),
      //                       child: Text('Error: ${snapshot.error}'),
      //                     )
      //                   ];
      //                 }
      //                 else {
      //                   switch (snapshot.connectionState){
      //                     case ConnectionState.none:
      //                       children = <Widget>[
      //                         Text('ConnectionState.none')
      //                       ];
      //                       break;
      //                     case ConnectionState.waiting:
      //                       children = <Widget>[
      //                         Text('로딩중...')
      //                       ];
      //                       break;
      //                     case ConnectionState.active:
      //                       children = <Widget>[
      //                         Text('ConnectionState.active')
      //                       ];
      //                       break;
      //                     case ConnectionState.done:
      //                       children = <Widget>[
      //                         Container(
      //                           width : double.infinity,
      //                           height : 300,
      //                           child : charts.PieChart(
      //                             snapshot.data,
      //                             animate: true,
      //                             animationDuration: Duration(milliseconds: 500),
      //                             behaviors: [
      //                               new charts.DatumLegend
      //                               (
      //                                 position: charts.BehaviorPosition.end, 
      //                                 outsideJustification: charts.OutsideJustification.endDrawArea,
      //                                 horizontalFirst: false,
      //                                 desiredMaxColumns: 2,
      //                                 cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
      //                                 entryTextStyle: charts.TextStyleSpec(
      //                                     color : charts.MaterialPalette.blue.shadeDefault,
      //                                     fontFamily: 'Gerogia',
      //                                     fontSize: 13
      //                                 ),
      //                               ),
      //                             ],
      //                             defaultRenderer: new charts.ArcRendererConfig(
      //                               arcWidth: 100,
      //                               arcRendererDecorators: [
      //                                 new charts.ArcLabelDecorator( 
      //                                   labelPosition: charts.ArcLabelPosition.inside
      //                                 )
      //                               ]
      //                             ),
      //                           )
      //                         )
      //                       ];
      //                       break;
      //                   }
      //                 }
      //                 return Container(
      //                   width : double.infinity,
      //                   height : 300,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: children,
      //                   )
      //                 );
      //               }
      //             )
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: <Widget>[
      //               Text('회차 : '),
      //               RaisedButton(
      //                 child : Text('${this.min_stage}'),
      //                 onPressed: () {
      //                   showDialogNumberPicker(
      //                     context, 
      //                     MIN_STAGE, 
      //                     MAX_STAGE, 
      //                     this.min_stage, 
      //                     (value){
      //                       setState((){
      //                         this.min_stage = value;
      //                       });
      //                     });
      //                 },
      //               ),
      //               Text('~'),
      //               RaisedButton(
      //                 child: Text('${this.max_stage}'),
      //                 onPressed: (){
      //                   showDialogNumberPicker(
      //                     context, 
      //                     MIN_STAGE, 
      //                     MAX_STAGE, 
      //                     this.max_stage,
      //                     (value) {
      //                       setState((){
      //                         this.max_stage = value;
      //                       });
      //                     });
      //                 },
      //               )
      //             ],
      //           ),
      //           Expanded(
      //             child: Container(
      //               child : SingleChildScrollView(
      //                 scrollDirection: Axis.vertical,
      //                 child : SingleChildScrollView(
      //                   scrollDirection: Axis.horizontal,
      //                   child : StreamBuilder<List<charts.Series<LottoSections, String>>>(
      //                     stream : pieStreams,
      //                     builder: (context, snapshot){
      //                     }),
      //                 ),
      //               )
      //             ),
      //           )
      //         ],
      //       )
      //     )
      //   )
      // ),
    );
  }
}