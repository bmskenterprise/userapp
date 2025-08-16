import 'dart:convert';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/models/Drive.dart';
import 'package:bmsk_userapp/models/Regular.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('auth');
  }
  
  Future<List<Drive>> fetchDrivepacks(String selectedOperator) async {
    try {
        //if(){
        final url =Uri.parse('${ApiConstants.drivePackage}?operator=$selectedOperator');
        final response = await http.get(
          url,
          headers: {'Authorization':'Bearer ${getAuth()[1]}',}
        );

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          /*allPacks =*/return data.map((json) => Drive.fromJson(json)).toList();
        }
        throw Exception('Failed to load drivepacks');
        /*for (Map operator in _operators) {
          _all[operator['name']] =
              allPacks
                  .where((pack) => pack.operator == operator['name'])
                  .toList(); //operator['drivepacks'].map((json) => Drive.fromJson(json)).toList();//llTodos.where((todo) => todo.completed).toList();
          //_all['incompleteTodos'] = allTodos.where((todo) => !todo.completed).toList();
        }*/
      } catch (err) {
        Toast({'message':err.toString(),'success':false});return [];
      }
  }
  
  
  Future<List<Regular>> fetchRegularpacks(String selectedOperator) async {
    try {
        //if(){
        final url =Uri.parse('${ApiConstants.regularPackage}?operator=$selectedOperator');
        final response = await http.get(
          url,
          headers: {'Authorization':'Bearer ${getAuth()[1]}',}
        );

        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          /*allPacks =*/return data.map((json) => Regular.fromJson(json)).toList();
        }
        throw Exception('Failed to load regularpacks');
        } catch (err) {
        Toast({'message':err.toString(),'success':false});return [];
      }
  }
  
  Future<bool> postDrive(String recipient,String opt/*, String acName, int amount, String billMonth*/) async {
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('${ApiConstants.driveHit}/${getAuth()[0]}'),
        headers: {'Content-Type':'application/json','Authorization':'Bearer ${getAuth()[1]}'},
        body: jsonEncode({'recipient':recipient,'opt':opt/*,'acName':acName,'amount':amount,'billMonth':billMonth*/})
      );
      if(response.statusCode==200) return true;
      throw Exception('সার্ভার সমস্যা') /*jsonDecode(response.body)*/;
    } catch (err) {
      Toast({'message':err.toString(),'sccess':false});return false;
    }
  }
      
      
  Future<bool> postBank(String bankType,String acNumber, String acName, int amount/*, String billMonth*/) async {
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('${ApiConstants.bank}/${getAuth()[0]}'),
        headers: {'Content-Type':'application/json','Authorization':'Bearer ${getAuth()[1]}'},
        body: jsonEncode({'bill':bankType,'acNumber':acNumber,'acName':acName,'amount':amount/*,'billMonth':billMonth*/})
      );
      
      if(response.statusCode==200) return true;
      throw Exception('সার্ভার সমস্যা') /*jsonDecode(response.body)*/;
      
    } catch (err) {
      Toast({'message':err.toString(),'success':false});return false;
    }
  }
  Future<bool> postBill(String billType, String acNumber, int amount, String billMonth, String acName) async {
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('${ApiConstants.bill}/${getAuth()[0]}'),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'bill':billType,'acNumber':acNumber,'acName':acName,'amount':amount,'billMonth':billMonth})
      );
      
      if(response.statusCode==200) return true;
      throw Exception('সার্ভার সমস্যা') /*jsonDecode(response.body)*/;
      
    } catch (err) {
      Toast({'message':err.toString(),'success':false});return false;
    }
  }
}