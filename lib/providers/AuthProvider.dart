import 'dart:convert';
import 'package:bmsk_userapp/services/AuthService.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  bool _matchedPIN=false;
  bool _loading=false;
  bool _loggedIn = false;
  String _username='';
  String _name = '';
  String _asyncError='';
  late Map<String, double> _balance;
  //late double _bankBalance;
  bool get matchedPIN => _matchedPIN;
  bool get loading => _loading;
  String get name => _name;
  String get username => _username;
  String get asyncError => _asyncError;
  Map<String, double> get balance => _balance;
  //double get bankBalance => _bankBalance;
  final _authService = AuthService();

  bool get loggedIn => _loggedIn;
  

  Future<void> checkLoginStatus() async {
    _loggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _loading=true;notifyListeners();
    final status/*user*/ = await _authService.login(username, password);
    if (status/*user!=null*/) {
      //_username=user;
      _loggedIn = true;SharedPreferences prefs=await SharedPreferences.getInstance();prefs.setBool('logged',_loggedIn);
      notifyListeners();
    }
    _loading=false;
    //return status/*user*/;
  }

  Future<void> logout() async {
    await _authService.logout();
    _loggedIn = false;
    notifyListeners();
  }
  Future<Map> changePassword(String oldPassword, String newPassword)async{
    _loading=true;
    notifyListeners();
    try {
      /*final res =await http.post(
        Uri.parse(ApiConstants.matchPassword),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'password':oldPassword})
      );
                    if(res.statusCode==200){
                      final data=jsonDecode(res.body);
                      if(!data['matched']){
        _asyncError='Wrong Password';notifyListeners();return {'message':'পাসওয়ার্ড ভুল দিয়েছেন', 'success':false};
      }*/
      final response = await http.post(
        Uri.parse(ApiConstants.changePassword),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'password':newPassword})
      );
      if(response.statusCode==400){
        _asyncError='পাসওয়ার্ড সঠিক না';notifyListeners();return jsonDecode(response.body);
      }
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
                    //}
      return {'message':'সার্ভার সমস্যা ', 'success':false};
    } catch (e) {print(e.toString());
      return {'message':'সার্ভার সমস্যা ', 'success':false};
    }finally {
      _loading=false;
      notifyListeners();
    }
      
  }
 void getBalanceData(String userName, String name/*, String pin*/)async {
    try{
      /*_userName = userName;*/final response = await http.get(Uri.parse('${ApiConstants.balance}$userName'));
      if(response.statusCode==200){
        Map data = jsonDecode(response.body);
        balance['topupBalance'] = data['topupBalance'];
        balance['bankBalance'] = data['bankBalance'];
      }
      // _pin = pin;
      //notifyListeners();
    }catch(e){}
 }
  void setTopupBalance(double b) {
    balance['topupBalance'] = b;
    notifyListeners();
  }

  void setBankBalance(double b) {
    balance['bankBalance'] = b;
    notifyListeners();
  }

  Future<dynamic> validatePIN(String pin) async{
    /*try {
      final response = await http.post(
        Uri.parse(ApiConstants.validatePIN),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'pin':pin})
      );*/_loading=true;notifyListeners();
      bool matched = await _authService.matchPIN(pin);
      /*if(response.statusCode==200){
        _matchedPIN=true;_loading=false;notifyListeners();return null;
      }else{
        _loading=false;notifyListeners();
        return jsonDecode(response.body);
      }
    }catch (e) {
      _loading=false;notifyListeners();
      return  {'message':'পরে চেষ্টা করুন', 'success':false};
    }*/_loading=false;notifyListeners();_matchedPIN=matched;notifyListeners();return matched;
  }

  void getBalance()async{
    final Map balanceData=await _authService.getBalance();
    balance['topupBalance']=balanceData['topupBalance'];
    balance['bankBalance']=balanceData['bankBalance'];
  }
  void disablePINConnection(){
    _matchedPIN=false;
    notifyListeners();
  }
}