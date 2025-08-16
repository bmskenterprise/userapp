import 'dart:convert';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FeedbackService {
  Future<List> fetchFeedbacks()async{
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await http.get(Uri.parse('${ApiConstants.feedback}/${pref.getString('user')}'));
      if(response.statusCode==200){
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load feedbacks');
    }catch(e){
      throw Exception(e.toString());
    }
  }

Future<bool> addFeedback(String subject, String message) async {
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(ApiConstants.feedback),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'subject':subject,'message':message,'user':pref.getString('user')})
      );
      if(response.statusCode!=200){
        throw Exception('Failed to add feedback');
      }
      return response.statusCode==200;
    }catch(e){
      return false/*{'message':e.toString(), 'success':false}*/;
    }
  }
  /*Future<Map> addFeedback(String subject, String message) async {
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(ApiConstants.feedback),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'subject':subject,'message':message,'user':pref.getString('user')})
      );
      if(response.statusCode!=200){
        throw Exception('Failed to add feedback');
      }
      return {'message':'Feedback added successfully', 'success':true};
    }catch(e){
      return {'message':e.toString(), 'success':false};
    }
  }*/
}