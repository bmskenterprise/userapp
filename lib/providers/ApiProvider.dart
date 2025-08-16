import 'package:bmsk_userapp/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:bmsk_userapp/models/Drive.dart';
import 'package:bmsk_userapp/models/Regular.dart';

class ApiProvider with ChangeNotifier{
  final ApiService _apiService=ApiService();
  bool _loading = false;
  late List<Drive> _currentDrivePacks;
  late Map<String, List<Drive>> _drives;
  late List<Regular> _currentRegularPacks;
  late Map<String, List<Regular>> _regulars;
  
  bool get loading => _loading;
  List<Drive> get currentDrivePacks => _currentDrivePacks;
  //bool _postStatus = false;
  List<Regular> get currentRegularPacks => _currentRegularPacks;


  Future<void> fetchDrivePacks(String opt) async {
    if (_drives.containsKey(opt)) {
      _currentDrivePacks=_drives[opt]!;
    } else {
      _currentDrivePacks = await _apiService.fetchDrivepacks(opt);_drives[opt]=_currentDrivePacks;
    }
  }
  Future<void> fetchRegularPacks(String opt)async{
    if(_regulars.containsKey(opt)) {_currentRegularPacks=_regulars[opt]!;}
    else {_currentRegularPacks=await _apiService.fetchRegularpacks(opt);_regulars[opt]=_currentRegularPacks;}
  }
  
  Future<bool> postDrive(String recipient, String opt/*, String price, int amount, String billMonth*/) async {
    _loading = true;notifyListeners();
    bool postStatus=await _apiService.postDrive(recipient, opt/*, price, amount, billMonth*/);
    _loading = false;notifyListeners();return postStatus;
  }
  Future<bool> postBill(String bill, String acNumber, int amount, String billMonth, String acName) async {
    _loading = true;notifyListeners();
    bool postStatus= await _apiService.postBill(bill, acNumber, amount, billMonth, acName);
    _loading = false;notifyListeners();return postStatus;
  }
  Future<bool> postBank(String bill, String acNumber, String acName, int amount/*, String billMonth*/) async {
    _loading = true;notifyListeners();
    bool postStatus=await _apiService.postBank(bill, acNumber, acName, amount/*, billMonth*/);
    _loading = false;notifyListeners();return postStatus;
  }
}