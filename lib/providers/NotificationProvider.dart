//import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class NotificationProvider with ChangeNotifier {
  int _failedDepositCount=0;
  int _failedTopupCount=0;
  int _failedDriveCount=0;
  int _failedRegularCount=0;
  int _failedBankCount=0;
  int _failedBillCount=0;
  int _failedBkashCount=0;
  int _failedDBBLCount=0;
  int _failedNagadCount=0;

  int get failedDepositCount => _failedDepositCount;
  int get failedTopupCount => _failedTopupCount;
  int get failedDriveCount => _failedDriveCount;
  int get failedRegularCount => _failedRegularCount;
  int get failedBankCount => _failedBankCount;
  int get failedBillCount => _failedBillCount;
  int get failedBkashCount => _failedBkashCount;
  int get failedDBBLCount => _failedDBBLCount;
  int get failedNagadCount => _failedNagadCount;
  int get totalUnseenCount => _failedDepositCount + _failedTopupCount + _failedDriveCount + _failedRegularCount + _failedBankCount + _failedBillCount;
  /* = await http.get(Uri.parse());
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
    } catch (err) {
      return 0;
    }
  }*/

  
  unseenDepositCount(int unseen){
    _failedDepositCount=unseen;notifyListeners();
  }
  unseenTopupCount(int unseen){
    _failedTopupCount=unseen;notifyListeners();
  }
  unseenDriveCount(int unseen){
    _failedDriveCount=unseen;notifyListeners();
  }
  unseenRegularCount(int unseen){
    _failedRegularCount=unseen;notifyListeners();
  }
  unseenBankCount(int unseen){
    _failedBankCount=unseen;notifyListeners();
  }
  unseenBillCount(int unseen){
    _failedBillCount=unseen;notifyListeners();
  }
  unseenBkashCount(int unseen){
    _failedBkashCount=unseen;notifyListeners();
  }
  unseenDBBLCount(int unseen){
    _failedDBBLCount=unseen;notifyListeners();
  }
  unseenNagadCount(int unseen){
    _failedNagadCount=unseen;notifyListeners();
  }
  /*fetchFailedBanksCount() async {
    try {
      final response = await http.get(Uri.parse());
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
    } catch (err) {
      return 0;
    }
  }
  fetchFailedBillsCount() async {
    try {
      final response = await http.get(Uri.parse());
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
    } catch (err) {
      return 0;
    }
  }*/
  seenDrive(){
    if(_failedDriveCount>0) _failedDriveCount=0;notifyListeners();
  }
  seenBank(){
    if(_failedBankCount>0) _failedBankCount=0;notifyListeners();
  }
  seenBill(){
    if(_failedBillCount>0) _failedBillCount=0;notifyListeners();
  }
}