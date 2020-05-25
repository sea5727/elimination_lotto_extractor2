

import 'dart:math';

enum Section{
  _1_to_10,
  _11_to_20,
  _21_to_30,
  _31_to_40,
  _41_to_45,
  _fail,
}

//Probability by section
class ProcLottoStatistics{
  List<bool> ballsLottoIsBlackChecked;
  List<int> ballsSelected;
  List<double> probabilityBySection;
  double total = 0.0;
  var _random = new Random();
  ProcLottoStatistics(this.ballsLottoIsBlackChecked, this.probabilityBySection){ //## len : 5, ex) [22.2, 22.2, 22.2, 22.2, 11.1] 
    this.ballsLottoIsBlackChecked[0] = false;
  
    this.ballsSelected = List<int>();
  
    this.probabilityBySection.asMap().forEach( (i, e) { 
        print(i.toString() + ' forEach element : ' + e.toString());
        total += e;
        
    });
    total = total * 100;
    print('total is ' + total.toString());
  }
  int procSelectLottoOne(Section section){
    int min;
    int max;
    int result = 0;
    switch(section){
      case Section._1_to_10: min = 1; max = 10; break;
      case Section._11_to_20: min = 11; max = 20; break;
      case Section._21_to_30: min = 21; max = 30; break;
      case Section._31_to_40: min = 31; max = 40; break;
      case Section._41_to_45: min = 41; max = 45; break;
      default: throw Exception('invalid section');
    }

    print('while start');
    bool isBreak = true;
    for(int i = min ; i <= max ; i++){
      if(ballsLottoIsBlackChecked[i] == true && !this.ballsSelected.contains(i)){
        isBreak = false;
      }
    }
    print('is Break???' + isBreak.toString());
    if(isBreak) {  // 더이상 뽑을게 없는경우
      return -1;
    }
    var v = _random.nextInt(max - min + 1) + min; // 0~9 
    if(!ballsLottoIsBlackChecked[v] || this.ballsSelected.contains(v)){ // black 번호, 이미 뽑은번호 인경우 실패,
      return -1;
    }
    print('random is ' + v.toString());
    ballsSelected.add(v);
    result = v;
    return result;
  }

  List<int> procSelectLotto(){
    int i = 0;
    while(true){
      if(i >= 6) break;
      var sect = procFirstSelectSecion();
      var result = procSelectLottoOne(sect);
      if(result == -1){ // 해당 section에서 뽑을수있는 숫자가 없음.
        continue;  
      }
      this.ballsSelected[i] = result;
      print('i : ' + i.toString() + ' ballSelect : ' + this.ballsSelected[i].toString());
      i += 1; 
    }
    return this.ballsSelected;
  }
  List<int> getSelectLotto(){
    return this.ballsSelected;
  }
  Section procFirstSelectSecion(){
    var v = _random.nextInt(total.toInt());
    var pbs = probabilityBySection;
    if(v < pbs[0] * 100){ // 1 ~ 10
      return Section._1_to_10;
    }
    else if(v < (pbs[0] + pbs[1]) * 100) { // 11 ~ 20 
      return Section._11_to_20;
    }
    else if(v < (pbs[0] + pbs[1] + pbs[2]) * 100) { // 21 ~ 30
      return Section._21_to_30;
    }
    else if(v < (pbs[0] + pbs[1] + pbs[2] +pbs[3]) * 100) { // 31 ~ 40
      return Section._31_to_40;
    }
    else{
      return Section._41_to_45;
    }
  }
}