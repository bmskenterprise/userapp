import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../util/baseURL.dart';
import '../widgets/Toast.dart';

class AuthService {
  //final String apiUrl = 'https://your-api.com/login'; // API URL

  Future<Map> getAuth()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('auth')??'{}') /*?? 'user'*/;
  }

  Future<bool> login(String username, String password) async {
    try{
      final res = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (res.statusCode == 200) {
        final data = Map.from(jsonDecode(res.body));
        //final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth', jsonEncode({'user':[data['token'],data['user'],data['level']],'accesses':data['accesses']}));
        //await prefs.setString('user', data['user']);
        return true/*data['user']*/;
      }
      throw Exception('failed to login');
    } catch(err) {Toast({'message':err.toString(),'success':false});return false;}
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth');
  }

  Future<void> editProfile() async{
    // Update profile logic here
    try {
      Map auth =await getAuth();
      final res =await http.post(
        Uri.parse(ApiConstants.updateProfile),
        headers: {'Content-Type':'application/json','Authorization':'Bearer ${auth['user'][0]}'},
        body: jsonEncode({''})
      );
      //if (response.statusCode == 
      if(res.statusCode==200) {}
        
      throw Exception('Failed to update profile');
    }catch(e) {Toast({'message':e.toString(),'success':false});} //(e) {
      // Handle error
    //}
  }
  Future changePIN(String pin) async {
    try{
      final res=await http.patch(
        Uri.parse(ApiConstants.changePIN),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'pin':pin})
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) {Toast({'message':decoded['message'],'success':false});return;}
      throw Exception(decoded['error']?? 'সার্ভার সমস্যা');
    }catch(e) {Toast({'message':e.toString(),'success':false});}
  }
     
    
    
    
                        /*requesting=true;
                    });
                    final response=await http.get(Uri.parse(ApiConstants.matchPassword));
                    if(response.statusCode==200){
                      final data=jsonDecode(response.body);
                        return data['matched'];
                      // });
                    } else{
                      // re
                    }*/

  Future<dynamic> changePassword(String oldPassword,String password) async{
    try{
      final res = await http.patch(
        Uri.parse(ApiConstants.changePassword),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'oldPassword':oldPassword,'password':password})
      );
      if(res.statusCode==200){Toast({'message':'পাসওয়ার্ড পরিবর্তন হয়েছে','success':true});return;}
      throw Exception('সার্ভার সমস্যা');
    }catch(e) {Toast({'message':e.toString(),'success':false});}   
  }
  
  Future<bool> matchPIN(String pin) async {
    try{
      final auth = await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.validatePIN),
        headers: {'Content-Type':'application/json', 'Authorization':'Bearer ${auth['user'][0]}'},
        body: jsonEncode({/*'user':authData['user'],*/ 'pin':pin}), // Replace with actual phone number
      );
      if(res.statusCode==200) {
        final data = Map.from(jsonDecode(res.body));
        if(data['matched']!=null&&data['matched']){return true;}
        else{ Toast({'message':'পিন সঠিক নয়','success':false});return false;}
      } 
      throw Exception('সার্ভার সমস্যা');
    }catch(e) {Toast({'message':e.toString(),'success':false});return false;} 
  }
  
  
  /*Future<Map> getBalance() async {
    try{
      final response = await http.get(Uri.parse(ApiConstants.balance));
      if(response.statusCode==200){return jsonDecode(response.body);}
        return jsonDecode(response.body);
      }
      throw Exception();
      return {'message':'সার্ভার সমস্যা ', 'success':false};
    }
  }*/
}
