import 'dart:async';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/counter.txt');
}


Future<int> readCounter() async {
  try {
    final file = await localFile;
    // Read the file
    String contents = await file.readAsString();
    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}