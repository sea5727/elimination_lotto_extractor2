import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
  
  
void showDialogNumberPicker(context, min, max, init, void Function(int) callback) {
  showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return new NumberPickerDialog.integer(
        title: new Text("회차를 선택하세요"),
        minValue: min,
        maxValue: max,
        initialIntegerValue: init,
      );
    }
  ).then((int value){
    if (value != null && callback != null) {
      callback(value);
    }
  });
}