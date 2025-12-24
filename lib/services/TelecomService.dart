import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../util/baseURL.dart';
import '../widgets/Toast.dart';


class TelecomService{
  Future<Map> getAuth() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('auth')??'{}');
  }
  
  Future<List<Map>> fetchTelecomOpts( ) async {
    try{
      final auth = await getAuth();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*if(prefs.containsKey('opts')) {/*_operators=*/return jsonEncode(prefs.getString('opts'))as List<Map>;}
      else{*/
        final res= await http.get(Uri.parse(ApiConstants.telecoms)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
        //_loading=false;notifyListeners();
        final decoded = jsonDecode(res.body);
        if(res.statusCode==200) {
          //await prefs.setString('opts',jsonEncode(res.body));
          return decoded!=null? List<Map>.from(decoded):[];//await prefs.setString('opts',response.body);
        }
        throw Exception('failed to fetch telecoms'); //notifyListeners();
      //}
    }catch(err){return [];}
  }

  Future<List<Map>> fetchTopupOpts() async {
    List operators=await fetchTelecomOpts();
    final auth=await getAuth();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*if(prefs.containsKey('topup-opts')){
      List<String>? opts=prefs.getStringList('topup-opts')!;
      /*_topupOpts=*/return opts.map((op)=>{'opt':op,'icon':operators.firstWhere((t)=>t['name']==op)}) as List<Map>;
      }
      else{*/
        final res= await http.get(Uri.parse(ApiConstants.topup)/*,headers: {'Authorization':'Bearer ${auth['user'][1]}'}*/);
        //_loading=false;notifyListeners();
        if(res.statusCode== 200) {
          //await prefs.setString('topup-opts',res.body);
          final decoded = jsonDecode(res.body);
          return decoded!=null?List<Map>.from(decoded): [];//await prefs.setStringList('topup-opts',response.body as List<String>);
        }
        throw Exception('failed to fetch topup opts'); //notifyListeners();
      //}
    }catch(err){/*_topupOpts=*/return [];}
    //finally{_loading=false;notifyListeners();}
  }

  
//movedfromOperatorListProvider.dart&namechanged
  Future<List<Map>> fetchDriveOpts(/*List<Map> operators*/) async {
    List operators=await fetchTelecomOpts();
    try{
      final auth =await getAuth();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*if(prefs.containsKey('drive-opts')){
        List<String>? opts= prefs.getStringList('drive-opts');
        /*_driveOpts=*/return opts!.map((op)=>{'name':op,'icon':operators.firstWhere((t)=>t['name']==op)}) as List<Map>;
      }
      else{*/
        final res= await http.get(Uri.parse(ApiConstants.drive)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
        if(res.statusCode== 200) {
          final decoded = jsonDecode(res.body);
          return decoded['driveOpts']!=null ? List<Map>.from(decoded['driveOpts']) :[];
          //notifyListeners();
        }
        throw Exception('failed to fetch drive opts');
      //}
    }catch(err){/*_driveOpts =*/return [];}
  }

  Future<List<Map>> fetchRegularOpts(/*List<Map> operators*/) async {
    List operators=await fetchTelecomOpts();
    try{
      final auth =await getAuth();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /*if(prefs.containsKey('regular-opts')){
        List<String>? opts= prefs.getStringList('regular-opts');
        /*_regularOpts=*/return opts!.map((op)=>{'name':op,'icon':operators.firstWhere((t)=>t['name']==op)}) as List<Map>;
      }
      else{*/
        final res= await http.get(Uri.parse(ApiConstants.regular)/*,headers:{'Authorization':'Bearer ${auth['user'][0]}'}*/);
        if(res.statusCode== 200) {
          final decoded = jsonDecode(res.body);
          return decoded['regularOpt']!=null? List<Map>.from(decoded['regularOpt']) :[];
        }
        throw Exception('failed to fetch regular opts');
      //}
    }catch(err){/*_regularOpts =*/return [];}
  }
          //notifyListeners();
  Future<bool> topup(String opt,String recipient,int amount)async{
    try{
      final auth =await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.topup),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body: jsonEncode({'operator':opt,'recipient':recipient,'amount':amount})
      );
      
      if(res.statusCode==201) {jsonDecode(res.body);return true;}
      //}
      throw Exception('failed to topup');
    }catch(e){Toast({'message':e.toString(),'success':false});return false;}
      //Toast({'message':e.toString(),'success':false});return false;
    //}
  }
  Future<Map<String,dynamic>> fetchDrivePacks(String selectedOpt,int page) async {
    try {
        //if(){
        final auth =await getAuth();
        final res = await http.get(
          Uri.parse('${ApiConstants.drive}/$selectedOpt?page=$page'),
          //headers: {'Authorization':'Bearer ${auth['user'][0]}',}
        );

        if(res.statusCode==200) {
          final decoded = jsonDecode(res.body);
          return decoded!=null ? Map<String,dynamic>.from(decoded): {}/*.map((json)=>Drive.fromJson(json)).toList()*/;
        }
        throw Exception('Failed to load drivepacks');
        /*for (Map operator in _operators) {
                _all[operator['name']] = allPacks.where((pack) => pack.operator == operator['name'])
                  .toList(); //operator['drivepacks'].map((json) => Drive.fromJson(json)).toList();//llTodos.where((todo) => todo.completed).toList();
          //_all['incompleteTodos'] = allTodos.where((todo) => !todo.completed).toList();
        }*/
      }catch(err) {Toast({'message':err.toString(),'success':false});return {};}// (err) {
  }
        //Toast({'message':err.toString(),'success':false});return [];
      //}
  
  Future<Map<String,dynamic>> fetchRegularPacks(String selectedOpt,int page) async {
    try {
        //if(){
        final auth =await getAuth();
        final res = await http.get(
          Uri.parse('${ApiConstants.regular}/$selectedOpt?page=$page'),
          //headers: {'Authorization':'Bearer ${auth['user'][0]}',}
        );

        if(res.statusCode==200) { //== 200) {
          final decoded = jsonDecode(res.body);
          return decoded ? Map<String,dynamic>.from(decoded): {}/*.map((json)=>Regular.fromJson(json)).toList()*/;
        }
        throw Exception('Failed to load regularpacks');
        }catch(err) {Toast({'message':err.toString(),'success':false});return {};}// (err) {
  }
      
  Future<bool> hitDrive(String recipient,Map drive/*, String acName, int amount, String billMonth*/) async {
    try {
      final auth=await getAuth();
      final res = await http.post(
        Uri.parse(ApiConstants.drive),
        headers: {'Content-Type':'application/json'/*,'Authorization':'Bearer ${auth['user'][0]}'*/},
        body: jsonEncode({'recipient':recipient,'drive':drive/*,'acName':acName,'amount':amount,'billMonth':billMonth*/})
      );
      if(res.statusCode==201) return true;
      throw Exception('সার্ভার সমস্যা');
    }catch(err) {Toast({'message':err.toString(),'success':false});return false;}// (err) {
  }
  
}