import 'dart:convert';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //final String apiUrl = 'https://your-api.com/login'; // API URL

  Future<List<String>?> getAuth()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('auth') /*?? 'user'*/;
  }

  Future<bool> login(String username, String password) async {
    try{
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('auth', [data['user'],data['token']]);
        //await prefs.setString('user', data['user']);
        return data['user'];
      }
throw Exception('failed to login');
    } catch(err) {Toast({'message':err.toString(),'success':false});
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  register(String username,String fullname,int nid,int pin,String password)async{
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'username':username,'fullname':fullname,'nid':nid,'password':password,'pin':pin})
      );
      if(response.statusCode==200){
        jsonDecode(response.body);//return;
      }
      throw Exception();
    } catch (err) {
      Toast({'message':err.toString(),'success':false});
    }
  }
  /*Future matchPassword(String password) async {
    setState((){
                        requesting=true;
                    });
                    final response=await http.get(Uri.parse(ApiConstants.matchPassword));
                    if(response.statusCode==200){
                      final data=jsonDecode(response.body);
                        return data['matched'];
                      // });
                    } else{
                      // re
                    }
  }*/

  Future<dynamic> changePassword(String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.changePassword),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'password':password})
    );
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    return {'message':'সার্ভার সমস্যা ', 'success':false};
  }
  
  Future<bool> matchPIN(String pin) async {
    try {
      final authData = await getAuth();
      final response = await http.post(
        Uri.parse('${ApiConstants.validatePIN}/${authData?[0]}'),
        headers: {'Content-Type':'application/json', 'Authorization':'Bearer ${authData?[1]}'},
        body: jsonEncode({/*'user':authData['user'],*/ 'pin':pin}), // Replace with actual phone number
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if(data['matched']){return true;}
        else{ Toast({'message':'পিন সঠিক নয়','success':false});return false;}
      } 
      throw Exception(); //return '';
      //}
    } catch (e) {
      return false;
    }
  }
  
  
  Future<Map> getBalance() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.balance));
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
      throw Exception();
    }catch (e) {
      return {'message':'সার্ভার সমস্যা ', 'success':false};
    }
  }
}
