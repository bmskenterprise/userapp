import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:bmsk_userapp/models/Drive.dart';
//import 'package:bmsk_userapp/models/Regular.dart';
import '../util/baseURL.dart';
import '../widgets/Toast.dart';


class ApiService {
  Future<Map> getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('auth')??'{}');
  }
  
  Future<List<String>?> fetchSliderImages() async {
    try{
      //SharedPreferences prefs =await SharedPreferences.getInstance();
      //final auth = await getAuth(); //List<Map>;
      /*if(prefs.containsKey('slider-images')){
        return prefs.getStringList('slidsr-images');
      }
      else{*/
        final res= await http.get(
          Uri.parse(ApiConstants.sliderURL),
          //headers:{'Aurhorization':'Bearer ${auth['user'][0]}'}
        );
        //_loading=false;notifyListeners();
        if(res.statusCode== 200) {
          final decoded= jsonDecode(res.body);
          final List<String> images = decoded['urls']!=null ? List<String>.from(decoded['urls']) : [];
          //prefs.setStringList('slider-images',images);
          return images;
        }
        throw Exception('সার্ভার সমস্যা ');
      //}
    }catch(err){Toast({'message': err.toString(),'success':false});return [];}
  }
       
      
       
      
      
      
  Future<List<String>> sendMoney(String provider,String recipient,int amount)async{
    try{
      final auth = await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.sendmoney),
        headers:{'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body:jsonEncode({'provider':provider,'recipient':recipient,'amount':amount})
      );
      if(res.statusCode==201)return jsonDecode(res.body);
      throw Exception();
    }catch(err) {return [];}
  }
  Future<bool> cashin(String provider,String recipient, int amount/*, String amount, String billMonth*/) async {
    try {
      final auth=await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.cashin),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body: jsonEncode({'provider':provider,'recipient':recipient,'amount':amount/*,'amount':amount,'billMonth':billMonth*/})
      );
      if(res.statusCode==201) return true;
      throw Exception('সার্ভার সমস্যা');
    }catch(err) {Toast({'message':err.toString(),'success':false});return false;}// (err) {
  }
  Future<bool> postBank(String bankType,String acNumber, String acName, int amount/*, String billMonth*/) async {
    try {
      final auth = await getAuth();
      final res = await http.post(
        Uri.parse('${ApiConstants.bank}/${auth['user'][0]}'),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][1]}'*/},
        body: jsonEncode({'bill':bankType,'acNumber':acNumber,'acName':acName,'amount':amount/*,'billMonth':billMonth*/})
      );
      if(res.statusCode==201) return true;
      throw Exception('সার্ভার সমস্যা');
    }catch(err) {Toast({'message':err.toString(),'success':false});return false;}
  }
  Future<bool> postBill(String billType, String acNumber, int amount, String billMonth, String acName) async {
    try {
      final auth = await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.bill),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body: jsonEncode({'bill':billType,'acNumber':acNumber,'acName':acName,'amount':amount,'billMonth':billMonth})
      );
      if(res.statusCode==201) return true;
      throw Exception('সার্ভার সমস্যা') /*jsonDecode(response.body)*/;
    }catch(err) {Toast({'message':err.toString(),'success':false});return false;}// (err) {
  }
  
  Future<List<Map<String,String>>> fetchContacts()async{
    try{
      final auth=await getAuth();
      final res = await http.get(Uri.parse(ApiConstants.contacts)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
      if(res.statusCode==200){
        final decoded = jsonDecode(res.body);
        return decoded['contacts']!=null ? List<Map<String,String>>.from(decoded['contacts']) : [];
      }
      throw Exception('failed to load contacts');
    }catch(e) {return [];}
  }
  
  Future<List<Map<String,String>>> fetchMbanks() async{
    try{
      final auth = await getAuth();
      final res = await http.get(Uri.parse(ApiConstants.mbanks)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
      if(res.statusCode==200){
        final decoded= jsonDecode(res.body);
        return decoded['mbanks']!=null ? List<Map<String,String>>.from(decoded['mbanks']) : [];
      }
      throw Exception('Failed to load mbanks');
    }catch(e) {Toast({'message':e.toString(),'success':false});return [];}
  }
  
  Future<List<String>> fetchBankNames()async {
    try{
      final auth = await getAuth();
      final res= await http.get(Uri.parse(ApiConstants.bank)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
      if(res.statusCode==200){
        final decoded = jsonDecode(res.body);
        return decoded['banks']!=null ? List<String>.from(decoded['banks']) : [];
      }
      throw Exception('Failed to load bank names');
    }catch(err){Toast({'message':err.toString(),'success':false});return [];}
  }
  Future<List> fetchFeedbacks()async{
    try{
      final auth = await getAuth();
      final res = await http.get(Uri.parse(ApiConstants.feedback)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
      if(res.statusCode==200){
        final decoded= jsonDecode(res.body);
        return decoded!=null ? List<Map>.from(decoded) : [];
      }
      throw Exception('Failed to load feedbacks');
    }catch(e) {throw Exception(e.toString());}
  }

Future<bool> addFeedback(/*String subject, */String description) async {
    try{
      final auth = await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.feedback),
        headers: {'Content-Type':'application/json;charset=utf-8'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body: jsonEncode({/*'subject':subject,*/'description':description/*,'user':getAuth()[1]*/})
      );
      if(res.statusCode!=201) throw Exception('Failed to add feedback');
      return res.statusCode==201;
    }catch(e) {Toast({'message':e.toString(), 'success':false});return false;}
  }
}
      //_loading=true;notifyListeners();
      //_loading=false;notifyListeners();
//movedfromOperatorListProvider.dart&namechanged
  /*Future<List<Map>> fetchDriveOpts(/*List<Map> operators*/) async {
    //_loading=true;notifyListeners();
  }

  Future<List<Map>> fetchRegularOpts(/*List<Map> operators*/) async {
    //_loading=true;notifyListeners();
    try{
      if(prefs.containsKey('drive-opts')){
        List<String>? opts= prefs.getStringList('drive-opts');
        /*_regularOpts=*/return opts!.map((op)=>{'op':op,'icon':_operators[op]['icon']}) as List<Map>;
      }
      else{
        final res= await http.get(Uri.parse(ApiConstants.drive));
        //_loading=false;notifyListeners();
        if(res.statusCode== 200) {
          /*_operators =*/return jsonDecode(res.body).driveOperators;
          //notifyListeners();
        }
        throw Exception();
      }
    }catch(err){/*_regularOpts =*/return [];}
  }
  Future<List<Map>> fetchDrivepacks(String selectedOperator) async {
    try {
        //if(){
        final url =Uri.parse('${ApiConstants.drivePackage}?operator=$selectedOperator');
        final res = await http.get(
          url,
          headers: {'Authorization':'Bearer ${getAuth()[1]}',}
        );

        if (res.statusCode == 200) {
          List<Map> data = jsonDecode(res.body);
          /*allPacks =*/return data/*.map((json) => Drive.fromJson(json)).toList()*/;
        }
        throw Exception('Failed to load drivepacks');
        /*for (Map operator in _operators) {
          _all[operator['name']] =
              allPacks
                  .where((pack) => pack.operator == operator['name'])
                  .toList(); //operator['drivepacks'].map((json) => Drive.fromJson(json)).toList();//llTodos.where((todo) => todo.completed).toList();
          //_all['incompleteTodos'] = allTodos.where((todo) => !todo.completed).toList();
        }*/
      }catch(err) {Toast({'message':err.toString(),'success':false});return [];}// (err) {
  }
        //Toast({'message':err.toString(),'success':false});return [];
      //}
  
  
  Future<List<Map>> fetchRegularpacks(String selectedOperator) async {
    try {
        final res = await http.get(
          Uri.parse('${ApiConstants.regularPackage}?operator=$selectedOperator'),
          headers: {'Authorization':'Bearer ${getAuth()[1]}',}
        );

        if(res.statusCode==200) {
          List<Map> data = jsonDecode(res.body);
          /*allPacks =*/return data/*.map((json) => Regular.fromJson(json)).toList()*/;
        }
        throw Exception('Failed to load regularpacks');
        }catch(err) {Toast({'message':err.toString(),'success':false});return [];}// (err) {
  }*/
        //Toast({'message':err.toString(),'success':false});return [];
      //}