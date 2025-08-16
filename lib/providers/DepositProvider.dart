import 'dart:convert';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class DepositProvider with ChangeNotifier{
  bool _loading=true;
  bool get loading=>_loading;
  bool _hasError=false;
  bool get hasError=>_hasError;
  late List _depositData;
  List get depositData=>_depositData;
  
  getAuth()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getStringList('auth');
  }
  
  Future<void> depositInfo()async{
    try{
      final response = await http.get(
        Uri.parse(ApiConstants.mbanks),
        headers: {'Content-Type':'application/json','Authorization':'Bearer ${getAuth()[1]}'},
      );
        _loading=false;notifyListeners();
      if (response.statusCode == 200){
        /*Map*/ _depositData= jsonDecode(response.body);
      }
      throw Exception();
     }catch(e) {
        _hasError = true;notifyListeners();
    }finally{_loading = false;notifyListeners();}//    
  }
  
  Future depositByTxnId(String txnid,[String? ref])async{
    try{
      final response = await http.post(
        Uri.parse('${ApiConstants.depositTxn}/${getAuth()[0]}'),
        headers: {'Content-Type':'application/json','Authorization':'Bearer ${getAuth()[1]}'},
        body: jsonEncode({'txnid':txnid,'ref':ref})
      );
      
      if(response.statusCode==200){
        jsonDecode(response.body);Toast({'message':'deposit success','success':true});
      }// 
    }catch(err){Toast({'message':'deposit failed','success':false});}
  }
}