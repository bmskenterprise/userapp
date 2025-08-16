//import 'dart:convert';
//import 'package:bmsk_userapp/models/History/BankHistory.dart';
//import 'package:bmsk_userapp/models/History/DepositHistory.dart';
//import 'package:bmsk_userapp/models/History/DriveHistory.dart';
//import 'package:bmsk_userapp/models/History/PayBillHistory.dart';
//import 'package:bmsk_userapp/models/History/TopupHistory.dart';
import 'package:bmsk_userapp/services/HistoryService.dart';
//import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HistoryProvider with ChangeNotifier {
final HistoryService _historyService = HistoryService();
  bool _loading=false;
  bool _filterInit=false;
  List _history=[];
  Map<String, List> _histories = {};
  bool get filterInit => _filterInit;
  bool get loading => _loading;
  List get history => _history;
  
getAuth() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('auth');
}

  Future fetchDepositHistory(String status) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchDepositHistory(status);
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
      _loading=false;notifyListeners();
    }*/
  }

  Future fetchTopupHistory(String status) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchTopupHistory(status);
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
      } else {
        throw Exception('Failed to load topup history');
      }
    } catch (e) {
      return [];
    }finally {
      _loading = false;notifyListeners();
    }*/
  }


  Future fetchDriveHistory(String status) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchDriveHistory(status);
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



  Future fetchPayBillHistory(String status) async {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchPayBillHistory(status)/* as List<BankHistory>*/;
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



  Future fetchBankHistory(String status) async {
    //try {
      if(_histories.containsKey(status)){_history=_histories[status]!;}
      else{
        _loading=true;notifyListeners();
      _histories[status]=await _historyService.fetchPayBillHistory(status)/* as List<BankHistory>*/;
        _history=_histories[status]!;
      _loading = false;
      notifyListeners();
      }
  }
  void filterDepositHistory (String query){
   _history=_history.where((h) => [h.type,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }  
  void filterTopupHistory (String query)  {
    _history = _history.where((h) => [h.recipient,h.telecom,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }      
  void filterDriveHistory (String query){
    _history = _history.where((h) => [h.recipient,h.telecom,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterRegularHistory (String query){
    _history = _history.where((h) => [h.recipient,h.telecom,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();
  }
  void filterBankHistory (String query)    {
    _history = _history.where((h) => [h.bankName,h.acNumber,h.amount].any((i) => i.contains(query))).toList();notifyListeners();
  }      
  void filterPayBillHistory (String query){
    _history = _history.where((h) => [h.type,h.acNumber,h.amount,h.date].any((i) => i.contains(query))).toList();notifyListeners();//   throw Exception('Failed to load bank history');
  }/*    }
      return [];
    }finally {*/
      void setFilterInit () async {
        _filterInit=!_filterInit;
      }
}