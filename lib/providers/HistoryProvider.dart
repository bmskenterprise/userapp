//import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
//import '../models/History/BankHistory.dart';
//import '../models/History/DepositHistory.dart';
//import '../models/History/DriveHistory.dart';
//import '../models/History/PayBillHistory.dart';
//import '../models/History/TopupHistory.dart';
import '../services/HistoryService.dart';
//import '../util/baseURL.dart';
//import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HistoryProvider with ChangeNotifier {
final HistoryService _historyService = HistoryService();
  bool _loading=false;
  late String _status;
  bool _filterInit=false;
  Map _history={};
  final Map<String, Map> _histories = {};
  String get status => _status;
  bool get filterInit => _filterInit;
  bool get loading => _loading;
  Map get history => _history;
  
getAuth() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return jsonDecode(prefs.getString('auth')??'{}');
}

    //   throw Exception('Failed to load bank history');
  changeStatus(String v){_status = v; }
    //_status = v;//return [];
  Future getDepositHistory(/*String status,*/[int? page]) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchDepositHistory(status,page);
        _history=_histories[status]!;
        _loading=false;notifyListeners();
      }
    /*try{
      _loading=true;notifyListeners();
      final response = await http.get(Uri.parse('${ApiConstants.depositHistory}?status=$status'));
      if(response.statusCode==200){
  List data=jsonDecode(response.body);
        /*deposits =*/return data.map((json) => DepositHistory.fromJson(json)).toList();//notifyListeners();
      }
      return [];
    }catch(e){
      return [];
    }finally{
      _loading=false;notifyListeners();}*/
  }

  Future getTopupHistory(/*String status,*/[int? page]) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchTopupHistory(status,page);
        _history=_histories[status]!;
        _loading=false;notifyListeners();
      }
    /*try {
      final response = await http.get(
        Uri.parse('${ApiConstants.topupHistory}?status=$status'),
        headers: {'Authorization': 'Bearer ${getAuth()[1]}'},
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        //setState(() {
          /*_topups =*/return data.map((json) => TopupHistory.fromJson(json)).toList();
          //_isLoading = false;
        //});
        throw Exception('Failed to load topup history');*/
  }

  Future getRegularHistory([int? page]) async{
    if(_histories.containsKey(status)){_history = _histories[status]!;}
    else{
      _loading = false;notifyListeners();
      _histories[status] = await _historyService.fetchRegularHistory(status,page);
      _history = _histories[status]!;
      _loading = false;notifyListeners();
    }
  }

  Future getDriveHistory(/*String status,*/[int? page]) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchDriveHistory(status,page);
        _history=_histories[status]!;
        _loading=false;notifyListeners();
      }
    /*try {
      _loading=true;notifyListeners();
      final response = await http.get(
        Uri.parse('${ApiConstants.driveHistory}?status=$status'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        //setState(() {
          /*_packs =*/return data.map((json) => Pack.fromJson(json)).toList();
          //_isLoading = false;
        //});//
      } else {
        throw Exception('Failed to load pack history');
      }
    } catch (e) {
      return [];
    }finally {
      _loading = false;
      notifyListeners();
    }*/
  }



  Future getPayBillHistory(/*String status,*/[int? page]) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchPayBillHistory(status,page)/* as List<BankHistory>*/;
        _history=_histories[status]!;
        _loading=false;notifyListeners();
      }
    /*try {
      _loading=true;notifyListeners();
      final response = await http.get(
        Uri.parse('${ApiConstants.billHistory}?status=$status'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        //setState(() {
          /*_balances =*/return data.map((json) => PayBillHistory.fromJson(json)).toList();
          //_isLoading = false;
        //});//
      } else {
        throw Exception('Failed to load balance history');
      }
    } catch (e) {
      return [];
    }finally {
      _loading = false;
      notifyListeners();
    }*/
  }



  Future getBankHistory(/*String status,*/[int? page]) async {
    //try {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchPayBillHistory(status,page)/* as List<BankHistory>*/;
        _history=_histories[status]!;
      _loading = false;
      notifyListeners();
      }
  }
  
  void getBkashHistory(/*String status,*/[int? page]) async{
    if(_histories.containsKey(status)){_history=_histories[status]!;}
    else{
      _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchBkashHistory(status,page);
      _history=_histories[status]!;
      _loading=false;notifyListeners();
    }
  }
  
  void getDBBLHistory(/*String status,*/[int? page]) async{
    if(_histories.containsKey(status)){_history=_histories[status]!;}
    else{
      _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchDBBLHistory(status,page);
      _history=_histories[status]!;
      _loading=false;notifyListeners();
    }
  }
  
  void getNagadHistory(/*String status,*/[int? page]) async{
    if(_histories.containsKey(status)){_history=_histories[status]!;}
    else{
      _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchNagadHistory(status,page);
      _history=_histories[status]!;
      _loading=false;notifyListeners();
    }
  }
  void filterDepositHistory (String query){
   _history=_history['deposits'].where((h) => [h.type,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }  
  void filterTopupHistory (String query)  {
    _history = _history['topups'].where((h) => [h.recipient,h.telecom,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }      
  void filterDriveHistory (String query){
    _history = _history['drives'].where((h) => [h.recipient,h.telecom,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterRegularHistory (String query){
    _history = _history['regulars'].where((h) => [h.recipient,h.telecom,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterBankHistory (String query)    {
    _history = _history['banks'].where((h) => [h.bankName,h.acNumber,h.amount].any((i) => i.contains(query))).toList();notifyListeners();
  }      
  void filterPayBillHistory (String query){
    _history = _history['bills'].where((h) => [h.type,h.acNumber,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterBkashHistory (String query){
    _history = _history['bkashes'].where((h) => [h.type,h.acNumber,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterDBBLHistory (String query){
    _history = _history['dbbls'].where((h) => [h.type,h.acNumber,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterNagadHistory (String query){
    _history = _history['nagads'].where((h) => [h.type,h.acNumber,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  
  
      void setFilterInit () async {
        _filterInit=!_filterInit;
      }
}