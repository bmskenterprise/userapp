import 'dart:convert';
import 'package:bmsk_userapp/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferService   {
  /*Map? transferData;
  late Map _balance;
  bool _loading = false;

  Map get balance => _balance;
  Map? get transfer => transferData;
  bool get loading => _loading;*/

getAuth() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('auth');
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
    //_balance=newBalance;
  }

  Future<bool> transfer(String recipient, String type, int amount) async{
    try{
      final authData=getAuth();
      final response = await http.post(
        Uri.parse('${ApiConstants.transfer}/${authData[0]}'),
        headers: {'Content-Type':'application/json', 'Authorization':'Bearer ${authData[1]}'},
        body: jsonEncode({'recipient':recipient,'type':type,'amount':amount})
      );
      
      if(response.statusCode==200){
        return true/*jsonDecode(response.body)*/;
      }
      throw Exception();
    }catch(e){
      Toast({'message':e.toString(),'success':false});return false;
    }/*finally{
    //}*/
  }

  Future transferInfo()async{
    try{
        //_loading=true;notifyListeners();
      final response = await http.get(Uri.parse(ApiConstants.transfer),headers:{'Authorization':'Bearer ${getAuth()[1]}'});
      //setState(() {
        //_loading=false;notifyListeners();
      //});
      if (response.statusCode == 200){
        /*Map transferData=*/return jsonDecode(response.body);
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
      }
     }catch(e) {
          print(e);
          }
  }
}