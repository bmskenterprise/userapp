import 'dart:convert';
import 'package:bmsk_userapp/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopupService{
  getAuth()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList('auth');
  }
  Future<bool> topup(String recipient,String opt,int amount)async{
    try{
      final response = await http.post(
        Uri.parse('${ApiConstants.topup}/${getAuth()[0]}'),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'recipient':recipient,'opt':opt,'amount':amount})
      );
      
      if(response.statusCode==200){
        jsonDecode(response.body);return true;
      }
      throw Exception();
    }catch(e){
      Toast({'message':e.toString(),'success':false});return false;
    }
  }
}