// import 'dart:convert';
// import 'package:bmsk_userapp/models/Operator.dart';
import 'dart:convert';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class OperatorListProvider with ChangeNotifier {
  bool _loading=false;
  late List _bankNames;
  List<String> _billTypes=[];late List<Map> _topupOpts;late List<Map> _driveOpts;
  Map _operators={'airtel':'http:localhost:5000/opt/airtel-logo_.png','banglalink':'http:localhost:5000/opt/bl-logo_.png',};

  Map get operators => _operators;
  bool get loading => _loading;
  List get bankNames => _bankNames;
  List<String> get billTypes => _billTypes;
  List<Map> get topupOpts => _topupOpts;
  List<Map> get driveOpts => _driveOpts;

getAuth()async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  return prefs.getStringList('auth');
}

  void getOperatorList(List<Map> operators) async {
    _loading=true;notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('opts')) {_operators=jsonEncode(prefs.getString('opts'))as Map<String,String>;}
      else{
        final response= await http.get(Uri.parse(ApiConstants.operatorList));
        _loading=false;notifyListeners();
        if(response.statusCode== 200) {
          _operators = jsonDecode(response.body);await prefs.setString('opts',response.body);
          notifyListeners();
        }
      }
    }catch(err){}
  }

  Future<void> getTopupTelecoms() async {
    _loading=true;notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('topup-opts')){
      List<String>? opts=prefs.getStringList('topup-opts')!;
      _topupOpts =opts.map((op)=>{'op':op,'icon':_operators[op]}) as List<Map>;
      }
      else{
        final response= await http.get(Uri.parse(ApiConstants.topup),headers: {'headers':'Bearer ${getAuth()[1]}'});
        _loading=false;notifyListeners();
        if(response.statusCode== 200) {
          _operators = jsonDecode(response.body);await prefs.setStringList('topup-opts', response.body as List<String>);
          notifyListeners();
        }
      }
    }catch(err){_topupOpts=[];}
    finally{_loading=false;notifyListeners();}
  }

  Future<void> getDriveOperators(/*List<Map> operators*/) async {
    _loading=true;notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('drive-opts')){
        List<String>? opts= prefs.getStringList('drive-opts');
        _driveOpts= opts!.map((op)=>{'op':op,'icon':_operators[op]}) as List<Map>;
      }
      else{
        final response= await http.get(Uri.parse(ApiConstants.drive));
        _loading=false;notifyListeners();
        if(response.statusCode== 200) {
          /*_operators =*/return jsonDecode(response.body).driveOperators;
          //notifyListeners();
        }
        throw Exception();
      }
    }catch(err){_driveOpts =[];}
  }
  /*void getRegularOperators(List<Map> operators) async {
    _loading=true;notifyListeners();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('opts')) _operators=prefs.getStringList('regular-opts');
      else{
        final response= await http.get(Uri.parse(ApiConstants.regularOperators));
        _loading=false;notifyListeners();
        if(response.statusCode== 200) {
          _operators = jsonDecode(response.body);
          notifyListeners();
        }
      }
    }catch{}
  }*/
  void resetOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('opts');
  }
  void resetTopupOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('topup-opts');
  }
  void resetDriveOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('drive-opts');
  }
  void resetRegularOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('regular-opts');
  }

void fetchBankNames(List<Map> operators) async {
  //_
}

  void fetchDriveList(List<Map> operators) async {
    _loading=true;notifyListeners();
    final response= await http.get(Uri.parse(ApiConstants.operatorList));
    _loading=false;notifyListeners();
    if(response.statusCode== 200) {
      _operators = jsonDecode(response.body);
      notifyListeners();
    }
  }


  void fetchBillTypes() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('billTypes')){
      _billTypes = prefs.getStringList('billTypes')!;
    }
    else{
      _loading=true;notifyListeners();
      final response= await http.get(Uri.parse(ApiConstants.operatorList));
      _loading=false;notifyListeners();
      if(response.statusCode== 200) {
        _billTypes = jsonDecode(response.body).map((e) => e['name']).toList();
        notifyListeners();
      }
    }
  }


  void fetchBankNamesFromApi5() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('bankNames')){
      _bankNames = prefs.getString('bankNames')!.split(RegExp(r'[\n,]'));
    }
    else{
      _loading=true;notifyListeners();
      final response= await http.get(Uri.parse(ApiConstants.operatorList));
      _loading=false;notifyListeners();
      if(response.statusCode== 200) {
        _bankNames = jsonDecode(response.body).map((e) => e['name']).toList();
        notifyListeners();
      }
    }
  }
}
