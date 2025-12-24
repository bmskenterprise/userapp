import 'package:flutter/material.dart';
import '../services/DepositService.dart';

class DepositProvider with ChangeNotifier{
  final DepositService _depositService=DepositService();
  bool _loading=true;
  bool get loading=>_loading;
  bool _hasError=false;
  bool get hasError=>_hasError;
  Map<String,int> _balance ={};
  List<Map> _pgws =[];
  List<Map> _mbanks =[];
  late Map _depositInit;
      
  List<Map> get mbanks=>_mbanks;
  Map get depositInit=>_depositInit;
  late Map<String, Map<String,int>> _depositRange;
  Map<String, Map<String,int>> get depositRange=> _depositRange;
  Map<String,int> get balance => _balance;
  List<Map> get pgws=>_pgws;
  
  void getMbanks() async{
    _mbanks = await _depositService.fetchMbanks();
  }
  void getDepositRangeInfo()async{
    _loading=true;notifyListeners();
    _depositRange= await _depositService.fetchDepositRangeInfo();
    _loading=false;notifyListeners();
  }
  
  void depositByTxnId(String txn,String type,[String? ref])async{
    _loading=true;notifyListeners();
    await _depositService.depositByTxnId(txn,type,ref);
    _loading=false;notifyListeners();
  }

  Future transfer(String recipient, String type, int amount) async{
    _loading = true;notifyListeners();
      final status = await _depositService.transfer(recipient, type, amount);_loading=false;notifyListeners();
      return status;
  }
  void getBalance()async{
    /*final Map<String,double> balanceData*/_balance=await _depositService.fetchBalance();
    //_balance['topup']=balanceData['topup'];
    //_balance['bank']=balanceData['bank'];
  }
  void getPGW()async{
    _pgws=await _depositService.fetchPGWs();notifyListeners();
  }
  
  void setDepositData(Map data)async{
    _depositInit=data;notifyListeners();
  }
}