import 'dart:convert';
import 'package:bmsk_userapp/models/History/BankHistory.dart';
import 'package:bmsk_userapp/models/History/DepositHistory.dart';
import 'package:bmsk_userapp/models/History/DriveHistory.dart';
import 'package:bmsk_userapp/models/History/PayBillHistory.dart';
import 'package:bmsk_userapp/models/History/TopupHistory.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmsk_userapp/Toast.dart'  ;


class HistoryService   {
  //List deposits=[];
  //bool get loading => _loading;
  
getAuth() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('auth');
}

  Future<List<DepositHistory>> fetchDepositHistory(String status) async {
    try{
      //_loading=true;notifyListeners();
      final response = await http.get(Uri.parse('${ApiConstants.depositHistory}?status=$status'));
      if(response.statusCode==200){
  List data=jsonDecode(response.body);
        /*deposits =*/return data.map((json) => DepositHistory.fromJson(json)).toList();//notifyListeners();
      }
      return [];
    }catch(e){
      return [];
    }finally{
      //_loading=false;notifyListeners();
    }
  }

  Future<List<TopupHistory>> fetchTopupHistory(String status) async {
    try {
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
      //_loading = false;notifyListeners();
    }
  }



  Future<List<Pack>> fetchDriveHistory(String status) async {
    try {
      //_loading=true;notifyListeners();
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
      //_loading = false;
      //notifyListeners();
    }
  }



  Future<List<PayBillHistory>> fetchPayBillHistory(String status) async {
    try {
      //_loading=true;notifyListeners();
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
      //_loading = false;
      //notifyListeners();
    }
  }



  Future<List<BankHistory>> fetchBankHistory(String status) async {
    try {
      //_loading=true;notifyListeners();
      final response = await http.get(
        Uri.parse('${ApiConstants.bankHistory}?status=$status'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        //setState(() {
          /*_balances =*/return data.map((json) => BankHistory.fromJson(json)).toList();
          //_isLoading = false;
        //});//
      } else {
        throw Exception('Failed to load bank history');
      }
    } catch (e) {
      Toast({'message':e.toString(),'success':false});return [];
    }finally {
      //_loading = false;
      //notifyListeners();
    }
  }
}