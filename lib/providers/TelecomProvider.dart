import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/TelecomService.dart';

class TelecomProvider with ChangeNotifier{
  final TelecomService _telecomService=TelecomService();
  bool _loading = false;
  late List<Map> _topupOpts;
  late List<Map> _driveOpts;
  late Map _currentDriveOpt;
  late Map _currentRegularOpt;
  late List<Map> _regularOpts;
  late Map<String,dynamic> _drivePacksByOpt;
  late Map<String, Map<String,dynamic>> _drives;
  late Map<String,dynamic> _regularPacksByOpt;
  late Map<String, Map<String,dynamic>> _regulars;
  late List<Map> _telecomOpts;//={'airtel':'http:localhost:5000/opt/airtel-logo_.png','banglalink':'http:localhost:5000/opt/bl-logo_.png',};
  
  bool get loading => _loading;
  List<Map> get telecomOpts => _telecomOpts;
  List<Map> get topupOpts => _topupOpts;
  List<Map> get driveOpts => _driveOpts;
  Map get currentDriveOpt => _currentDriveOpt;
  List<Map> get regularOpts => _regularOpts;
  Map get currentRegularOpt => _currentRegularOpt;
  Map<String,dynamic> get drivePacksByOpt => _drivePacksByOpt;
  //bool _postStatus = false;
  Map<String,dynamic> get regularPacksByOpt => _regularPacksByOpt;
  
  getTelecomOpts()async{
    _telecomOpts=await _telecomService.fetchTelecomOpts();
  }
  
  Future getTopupOpts()async{
    _topupOpts=await _telecomService.fetchTopupOpts();
  }

  Future getDriveOpts()async{
    _loading=true;notifyListeners();/*List<String>?*/ _driveOpts = await _telecomService.fetchDriveOpts();
    _loading=false;notifyListeners();//_driveOpts= opts!.map((op)=>{'opt':op,'icon':_operators[op]}) as List<Map>;
  }
  Future getRegularOpts()async{
    _loading=true;notifyListeners();/*List<String>?*/ _regularOpts = await _telecomService.fetchRegularOpts();
    _loading=false;notifyListeners();//_regularOpts= opts!.map((op)=>{'opt':op,'icon':_operators[op]}) as List<Map>;
  }
  void onDriveOptChange(String operator){
    _currentDriveOpt=_driveOpts.firstWhere((opt)=> opt['name']==operator );
    getDrivePacks(1);
  }
  void onRegularOptChange(String operator){
    _currentRegularOpt=_regularOpts.firstWhere((opt)=> opt['name']==operator );
    getRegularPacks(1);
  }
  Future<void> getDrivePacks(int page) async {
    if (_drives.containsKey(currentDriveOpt['name'])) {
      _drivePacksByOpt=_drives[currentDriveOpt['name']]!;
    } else {
      _drivePacksByOpt = await _telecomService.fetchDrivePacks(currentDriveOpt['name'],page);
      _drives[currentDriveOpt['name']]=_drivePacksByOpt;
    }
  }
  Future<void> getRegularPacks(int page)async{
    if(_regulars.containsKey(currentRegularOpt['name'])) {_regularPacksByOpt=_regulars[currentRegularOpt['name']]!;}
    else {
      _regularPacksByOpt=await _telecomService.fetchRegularPacks(currentRegularOpt['name'],page);
      _regulars[currentRegularOpt['name']]=_regularPacksByOpt;
    }
  }
  filterDrive(String query){
    _drivePacksByOpt['drives'].where((c)=> c.name.toLowerCase().contains(query.toLowerCase(),)).toList();
  }
  
  Future<bool> topup(String opt,String recipient,int amount)async{
    _loading=true;notifyListeners();
    bool status= await _telecomService.topup(opt, recipient, amount);
    _loading=false;notifyListeners();return status;
  }
  
  Future<bool> hitDrive(String recipient, Map drive/*, String price, int amount, String billMonth*/) async {
    _loading = true;notifyListeners();
    bool postStatus=await _telecomService.hitDrive(recipient, drive/*, price, amount, billMonth*/);
    _loading = false;notifyListeners();return postStatus;
  }
  void resetOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('opts');
  }
  void resetTopupOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('topup-opts');
  }
  void resetDriveOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('drive-opts');
  }
  void resetRegularOperators() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('regular-opts');
  }
}