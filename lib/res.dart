import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


//

class Resource{
  static final Resource _instance = Resource._internal();

  Map<String, Widget> mymap;
  List<bool> bIsWhite;
  String name;
  factory Resource(){
    return _instance;
  }

  Resource._internal(){
    mymap = Map<String, Widget>();
    name = 'test internal';
    bIsWhite = new List<bool>.filled(46, true);
    bIsWhite[0] = false;
  }

  Widget getImage(String key){
    if(mymap.containsKey(key)){
      return mymap[key];
    }
    var path = 'assets/images/' + key + '.jpg';
    var img = Image.asset(path);
    mymap[key] = img;
    return img;
  }
  void setIsWhite(int idx, bool checked){
    this.bIsWhite[idx] = checked;
  }
  List<bool> getIsWhite(){
    return bIsWhite;
  }

}

