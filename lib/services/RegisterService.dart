import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
import '../widgets/Toast.dart';
import '../util/baseURL.dart';


class RegisterService {
     Future<List<Map<String,dynamic>>> fetchUserLevels() async{
    try {
      final res = await http.get(Uri.parse(ApiConstants.register));
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200){return decoded!=null ? List<Map<String,dynamic>>.from(decoded):[];}
      Toast({'message':'সার্ভার সমস্যা ','success':false});
      throw Exception('failed to fetch user levels');
    }catch(err){return [];}
  }
  
  
  Future register(String level,String username,String fullname,int nid,int pin,String password)async{
    try {
      final res = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'level':level,'username':username,'fullname':fullname,'nid':nid,'pin':pin,'password':password})
      );
      if(res.statusCode==200){
        Map data= jsonDecode(res.body);//return;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth', jsonEncode({'user':[data['token'],data['user'],data['level']],'accesses':data['accesses']}));
      }
      throw Exception();
    }catch(e) {Toast({'message':e.toString(),'success':false});}
  }
  Future<bool> regFeeTXN(String txn,String ref) async{
    try{
      final res = await http.post(
        Uri.parse(ApiConstants.register),
        body:jsonEncode({'txn':txn,'ref':ref})
      );
      if(res.statusCode==200){return true;}
      Toast({'message':'server problem','success':false});throw Exception() ;
    }catch(e) {return false;}
  }
  Future<String> fetchOTP(String recipient)async{
    try{
      final res = await http.post(
        Uri.parse('${ApiConstants.register}/otp'),
        body:jsonEncode({'recipient':recipient})
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200){return decoded!=null? Map.from(decoded)['opt']:'';}
      throw Exception('server problem');
    }catch(e){Toast({'message':e.toString(),'success':false});return '';}
  }
}