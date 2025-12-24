import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../util/baseURL.dart';
import '../widgets/Toast.dart';

class AppService {
  Future<Map> getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('auth')??'{}');
  }
  Future<List<String>> fetchSliderURLs() async {
    final auth = await getAuth();
    try {
      final res = await http.get(
        Uri.parse(ApiConstants.sliderURL),
        headers:{'Authorization':'Bearer ${auth['user'][0]}'}
      );
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200) {
        //return jsonDecode(res.body);
        return decoded['urls']!=null ? List<String>.from(decoded['urls']) : []; //data.map((json)=>Balance.fromJson(json)).toList();
          /*_isLoading = false;});*/
      }else {throw Exception('Failed to load slider images');}
    }catch(e) {return [];}
  }
  Future<List> fetchNotices() async{
    final auth=await getAuth();
    try{
      final res= await http.get(Uri.parse(ApiConstants.notice),headers:{'Authorization':'Bearer ${auth['user'][0]}'});
      final decoded = jsonDecode(res.body);
      if(res.statusCode==200){return decoded!=null ? List.from(decoded) :[];}
      throw Exception('Failed to load notices');
    }catch(e) {Toast({'message':e.toString(),'success':false});return [];}
     //Exception('Failed to load balance history');
  }
}