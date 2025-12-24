//import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import '../services/AuthService.dart';
import '../services/RegisterService.dart';
//import '../util/baseURL.dart';


class AuthProvider with ChangeNotifier {
  bool _matchedPIN=false;
  bool _loading=false;
  bool _loggedIn = false;
  String _username='';
  String _name = '';
  String _asyncError='';
  //late Map<String, double> _balance;
  Map _authPrefs ={};
  bool get matchedPIN => _matchedPIN;
  bool get loading => _loading;
  String get name => _name;
  String get username => _username;
  String get asyncError => _asyncError;
  //Map<String, double> get balance => _balance;
  Map get authPrefs => _authPrefs;
  final _authService = AuthService();
  final _registerService = RegisterService();
  bool get loggedIn => _loggedIn;

  void getAuth() async{
    _authPrefs = await _authService.getAuth();notifyListeners();// as Map;
                    //}
    //return status/*user*/;
  }
  Future<void> checkLoginStatus() async {
    _loggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }
  Future <void> register(Map regData/*,String username,String fullname,int nid,int pin,String password*/) async {
    _loading=true;notifyListeners();
    bool status = await _registerService.register(regData['level'],regData['username'],regData['fullname'],regData['nid'],regData['pin'],regData['password']);
    if(status){_loggedIn=true;notifyListeners();}
    _loading=false;notifyListeners();
  }
  Future<void> login(String username, String password) async {
    _loading=true;notifyListeners();
    bool status/*user*/ = await _authService.login(username, password);
    if (status/*user!=null*/) {
      //_username=user;
      _loggedIn = true;//SharedPreferences prefs=await SharedPreferences.getInstance();prefs.setBool('logged',_loggedIn);
      notifyListeners();
    }
    _loading=false;notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _loggedIn = false;
    notifyListeners();
  }
  Future<void> changePassword(String oldPassword, String newPassword)async{
    _loading=true;
    notifyListeners();
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
      _loading = true;notifyListeners();
       await _authService.changePassword(oldPassword,newPassword);
        /*Uri.parse(ApiConstants.changePassword),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'oldPassword':oldPassword,'password':newPassword})
      );*/
      /*if(res.statusCode==400){
        _asyncError='পাসওয়ার্ড সঠিক না';notifyListeners();return jsonDecode(res.body);
      }
      if(res.statusCode==200){
        return jsonDecode(res.body);
      }
      return {'message':'সার্ভার সমস্যা ', 'success':false};
    } catch (e) {print(e.toString());
      return {'message':'সার্ভার সমস্যা ', 'success':false};
      _loading=false;
    }*/
  }
  Future<void> changePIN(String pin) async{
    _loading =true;notifyListeners();
    await _authService.changePIN(pin);
    _loading = false;notifyListeners();
  }
  /*void getBalanceData(String userName, String name/*, String pin*/)async {
    try{
      /*_userName = userName;*/final res = await http.get(Uri.parse('${ApiConstants.balance}$userName'));
      if(res.statusCode==200){
        Map data = jsonDecode(res.body);
        balance['topup'] = data['topup'];
        balance['bank'] = data['bank'];
      }
      // _pin = pin;
      //notifyListeners();
    }catch(e){}
  }
  void setTopupBalance(double b) {
    balance['topup'] = b;
    notifyListeners();
  }

  void setBankBalance(double b) {
    balance['bank'] = b;
    notifyListeners();
  }*/

  void editProfile() async {
    /*_loading = true;notifyListeners();
    final res = await _authService.editProfile();
    _loading = false;notifyListeners();*/
        
  }
         
         
  Future<dynamic> validatePIN(String pin) async{
      _loading=true;notifyListeners();
      bool matched = await _authService.matchPIN(pin);
      /*if(res.statusCode==200){
        _matchedPIN=true;_loading=false;notifyListeners();return null;
      }else{
        _loading=false;notifyListeners();
        return jsonDecode(res.body);
      }
    }catch (e) {
      _loading=false;notifyListeners();
      return  {'message':'পরে চেষ্টা করুন', 'success':false};
    }*/_loading=false;notifyListeners();_matchedPIN=matched;notifyListeners();return matched;
  }

  /*void getBalance()async{
    final Map balanceData=await _authService.getBalance();
    balance['topupBalance']=balanceData['topup'];
    balance['bankBalance']=balanceData['bank'];*/
  void disablePINConnection(){
    _matchedPIN=false;
    notifyListeners();
  }
}