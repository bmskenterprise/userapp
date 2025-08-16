//import 'dart:convert';
import 'package:bmsk_userapp/services/TransferService.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferProvider with ChangeNotifier {
  final _transferService = TransferService();
  Map? _transferData;
  late Map _balance;
  bool _loading = false;

  Map get balance => _balance;
  Map? get transferData => _transferData;
  bool get loading => _loading;

getAuth() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth');
}
  /*void getBalance(String user) async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('balance')){ _balance= prefs.getDouble('balance');}
      else{
        final response = await http.get(Uri.parse('${ApiConstants.balance}/$user'));
        if(response.statusCode==200){
          _balance = jsonDecode(response.body).balance;
        }
      }
    } catch (e) {
      
    }
  }*/

  void setBalance(newBalance){
    _balance=newBalance;
  }

  Future transfer(String recipient, String type, int amount) async{
    //try{
      _loading=true;notifyListeners();
      final status = await _transferService.transfer(recipient, type, amount);_loading=false;notifyListeners();
      return status;
      /*if(response.statusCode==200){
        jsonDecode(response.body);
      }*/
    /*}catch(e){
      print(e.toString());
    }finally{
      _loading=false;notifyListeners();
    }*/
  }

  Future transferInfo()async{
    try{
        _loading=true;notifyListeners();
      final response = await _transferService.transferInfo();
      //setState(() {
        _loading=false;notifyListeners();
      //});
      //if (response.statusCode == 200){
        /*Map*/ //transferData= jsonDecode(response.body);
        /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Transfer Balance!"),
            content: Column(
              children:[Text("minimum \u09F3${transferData?['min']} "), Text("maximum \u09F3${transferData?['max']} .")]
            ),
            actions: [
              TextButton(
                child: Text("ok"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );*/
      //}
     }catch(e) {
          print(e);
          }
  }
}