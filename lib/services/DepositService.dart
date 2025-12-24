import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/Toast.dart';
import '../util/baseURL.dart';
//import 'package:flutter/widgets.dart';


class DepositService  {
  Future<Map> getAuth()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('auth')??'{}');
  }
  
      
  Future<Map<String,Map<String,int>>> fetchDepositRangeInfo()async{
    try{
      final auth = await getAuth();
      final res = await http.get(Uri.parse('${ApiConstants.depositInfo}/${auth['user'][2]}')/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
      //setState(() {
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) return decoded!=null? Map<String,Map<String,int>>.from(decoded):{};
        /*Map*/ //_depositRange= jsonDecode(response.body);//notifyListeners();
      throw Exception('failed to fetch deposit range info');
    }catch(e) {return {};}
  }
          
          
  Future<List<Map>> fetchMbanks()async{
    try{
      final auth = await getAuth();
      final res = await http.get(
        Uri.parse(ApiConstants.mbanks),
        //headers: {'Authorization':'Bearer ${auth['user'][0]}'},
      );
      if(res.statusCode==200) return jsonDecode(res.body);
        /*Map*/ //_depositData= jsonDecode(response.body);
      //}
      throw Exception('Failed to fetch mbanks');
     }catch(e) {Toast({'message':e.toString(),'success':false});return [];}
  }
  
  Future depositByTxnId(String txn,String type,[String? ref])async{
    try{
      final auth = await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.depositByTxnId),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body: jsonEncode({'txn':txn,'balanceType':type,'ref':ref})
      );
      
      if(res.statusCode==201) {jsonDecode(res.body);Toast({'message':'deposit success','success':true});}
      throw Exception('failed to deposit ');
    }catch(err){Toast({'message':'deposit failed','success':false});}
  }
      //}// 

        //jsonDecode(response.body);Toast({'message':'deposit success','success':true});
  Future<bool> transfer(String recipient, String type, int amount) async{
    try{
      final auth=await getAuth();
      final res = await http.post(
        Uri.parse('${ApiConstants.transfer}/${auth[0]}'),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/}, 
        body: jsonEncode({'recipient':recipient,'balanceType':type,'amount':amount})
      );
      
      if(res.statusCode==200) return true/*jsonDecode(response.body)*/;
      throw Exception('failed to transfer');
    }catch(e){Toast({'message':e.toString(),'success':false});return false;}
  }  
  
  Future<Map<String,int>> fetchBalance() async {
    try {
      final auth = await getAuth();
      final res = await http.get(Uri.parse(ApiConstants.balance),
        //headers: {'Authorization':'Bearer ${auth['user'][0]}'}
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200){return decoded!=null ? Map<String,int>.from(decoded):{};}
      
      throw Exception('সার্ভার সমস্যা');
    }catch(e) {Toast({'message':e.toString(),'success':false});return {};}
  }
  Future<List<Map>> fetchPGWs() async{
    try{
      final auth = await getAuth();
      final res = await http.get(
        Uri.parse(ApiConstants.pgw),
        headers: {'Content-Type':'application/json','Authorization':'Bearer ${auth['user'][0]}'}
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) return decoded!=null ? List<Map>.from(decoded):[];
      throw Exception('Failed to get pgw');
    }catch(e) {Toast({'message':e.toString(),'success':false});return [];}
  }
}