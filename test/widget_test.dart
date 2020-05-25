// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elimination_lotto_extractor2/main.dart';

import 'package:elimination_lotto_extractor2/proc_lotto_select.dart';
import 'package:elimination_lotto_extractor2/lotto_statistics_view.dart';
import 'package:elimination_lotto_extractor2/res.dart';


void main() {
    testWidgets('TestSingleton', (WidgetTester tester) async {

    });


  testWidgets('TestProcSelect', (WidgetTester tester) async {
    var balls = List<bool>.filled(46, true);
    balls[0] = false;
    balls.fillRange(1, 9, false);
    balls.fillRange(11, 19, false);
    balls.fillRange(21, 29, false);
    balls.fillRange(31, 39, false);
    int count = 1;
    var results = List<List<int>>();
    for(int i = 0 ; i < count ; i++){
      var aver = [22.2, 22.2, 22.2, 22.2, 11.1];
      var pls = ProcLottoStatistics(balls, aver);
      var result = pls.procSelectLotto();
      results.add(result);
    }
    for(int i = 0 ; i < results.length ; i++){
      String bs = '';
      for(int j = 0 ; j < results[i].length ; j++){
        bs +=  results[i][j].toString() + ', ';
      }
      print('lotto : ' + bs);
    }
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
