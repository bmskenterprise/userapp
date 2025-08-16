import 'dart:convert';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class PackService {
  getAuth()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('auth');
  }
  packHit(String recipient, String pack) async {
    final response = await http.post(
      Uri.parse(ApiConstants.pack),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'recipient':recipient, 'pack':pack, 'user':getAuth()[0]})
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      return {'status': 'failed', 'message': 'Something went wrong'};
    }
  }
}