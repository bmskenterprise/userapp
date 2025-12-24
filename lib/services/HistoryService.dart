import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import '../models/History/BankHistory.dart';
//import '../models/History/DepositHistory.dart';
//import '../models/History/DriveHistory.dart';
//import '../models/History/PayBillHistory.dart';
//import '../models/History/TopupHistory.dart';
import '../util/baseURL.dart';
import '../widgets/Toast.dart'  ;


class HistoryService   {
  Map? _authCache;
  //bool get loading => _loading;
  Future<Map> getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _authCache= jsonDecode(prefs.getString('auth')??'{}');
    return _authCache!;
  }

  Future<Map<String,dynamic>> fetchDepositHistory(String status,[int? page,String? txn]) async {
    try{
      //_loading=true;notifyListeners();
      //final auth = await getAuth();
      final res = await http.get(
        Uri.parse('${ApiConstants.depositHistory}?status=$status&txn=$txn&page=$page'),
        //headers:{'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      if(res.statusCode==200){
        final decoded=jsonDecode(res.body);
        return decoded!=null? Map<String,dynamic>.from(decoded) : {};//.map((json)=>DepositHistory.fromJson(json)).toList();//notifyListeners();
      }
      throw Exception();
    }catch(e){return {};}
    finally{
      //_loading=false;notifyListeners();
    }
  }

  Future<Map<String,dynamic>> fetchTopupHistory(String status,[int? page,String? recipient]) async {
    try {
      //final auth=await getAuth();
      final res = await http.get(
        Uri.parse('${ApiConstants.topupHistory}?status=$status&recipient=$recipient&page=$page'),
        //headers: {'Authorization': 'Bearer ${_authCache!['user'][0]}'},
      );
      if(res.statusCode==200) {
        final decoded = jsonDecode(res.body);
        return decoded!=null ? Map<String,dynamic>.from(decoded) : {}; //decoded.map((json)=>TopupHistory.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch topup history');
    }catch(e) {return {};}
    finally {}
  }
  Future<Map<String,dynamic>> fetchRegularHistory(String status, [int? page,String? recipient]) async{
    try{
      //final auth = await getAuth();
      final res = await http.get(
        Uri.parse('${ApiConstants.regularHistory}?status=$status&recipient=$recipient&page=$page'),
        //headers:{'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      if(res.statusCode==200) {
        final decoded = jsonDecode(res.body);
        return decoded!=null ? Map<String,dynamic>.from(decoded) : {};
      }
      throw Exception('Failed to fetch');
    }catch(e) {return {};}
  }



  Future<Map<String,dynamic>> fetchDriveHistory(String status,[int? page,String? recipient]) async {
    try {
      //final auth=await getAuth();
      final res = await http.get(
        Uri.parse('${ApiConstants.driveHistory}?status=$status&recipient=$recipient&page=$page'),
        //headers:{'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body).drives;
        return decoded!=null ? Map<String,dynamic>.from(decoded) : {}; //.map((json)=>Pack.fromJson(json)).toList();
          //_isLoading = false;
      } else {
        throw Exception('Failed to load pack history');
      }
    }catch(e) {return {};}
    finally {
      //notifyListeners();
    }
  }



  Future<Map<String,dynamic>> fetchPayBillHistory(String status,[int? page,String? ac]) async {
    try {
      //_loading=true;notifyListeners();
      //final auth=await getAuth();
      final res = await http.get(
        Uri.parse('${ApiConstants.billHistory}?status=$status&ac=$ac&page=$page'),
        //headers:{'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        //setState(() {
        return decoded!=null ? Map<String,dynamic>.from(decoded) : {}; //.map((json)=>PayBillHistory.fromJson(json)).toList();
          //_isLoading = false;
      } else {
        throw Exception('Failed to load balance history');
      }
    }catch(e) {return {};} //{
    finally {
      //notifyListeners();
    }
  }



  Future<Map<String,dynamic>> fetchBankHistory(String status,[int? page,String? ac]) async {
    try {
      //_loading=true;notifyListeners();
      
      //final auth = await getAuth();
      final response = await http.get(
        Uri.parse('${ApiConstants.bankHistory}?status=$status&ac=$ac&page=$page'),
        //headers:{'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      if(response.statusCode==200) {
        final decoded = jsonDecode(response.body).banks;
        //setState(() {
        return decoded!=null ? Map<String,dynamic>.from(decoded) : {}; //.map((json)=>BankHistory.fromJson(json)).toList();
          //_isLoading = false;
      }else {throw Exception('Failed to load bank history');}
      //  throw Exception('Failed to load bank history');
    }catch(e) {Toast({'message':e.toString(),'success':false});return {};}
  }
 /*     Toast({'message':e.toString(),'success':false});return {};*/
  Future<Map<String,dynamic>> fetchBkashHistory(String status,[int? page]) async{
    try{
      //final auth =await getAuth();
      final res =await http.get(
        Uri.parse('${ApiConstants.bkashHistory}?status=$status&page=$page'),
        //headers: {'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) {return decoded!=null ? Map<String,dynamic>.from(decoded) : {};}
      throw Exception(decoded.error?? 'failed to fetch bkash history');
    }catch(e) {Toast({'message':e.toString(),'success':false});return {};}
  }
      
  Future<Map<String,dynamic>> fetchDBBLHistory(String status,[int? page]) async{
    try{
      //final auth =await getAuth();
      final res =await http.get(
        Uri.parse('${ApiConstants.dbblHistory}?status=$status&page=$page'),
        //headers: {'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) {return decoded!=null ? Map<String,dynamic>.from(decoded) : {};}
      throw Exception(decoded.error?? 'failed to fetch dbbl history');
    }catch(e) {Toast({'message':e.toString(),'success':false});return {};}
  }
  Future<Map<String,dynamic>> fetchNagadHistory(String status,[int? page]) async{
    try{
      //final auth =await getAuth();
      final res =await http.get(
        Uri.parse('${ApiConstants.nagadHistory}?status=$status&page=$page'),
        //headers: {'Authorization':'Bearer ${_authCache['user'][0]}'}
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) {return decoded!=null ? Map<String,dynamic>.from(decoded) : {};}
      throw Exception(decoded.error?? 'failed to fetch nagad history');
    }catch(e) {Toast({'message':e.toString(),'success':false});return {};}
  }
}