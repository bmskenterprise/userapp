import 'dart:io';
import 'package:flutter/material.dart';
import '../services/RegisterService.dart';

class RegisterProvider with ChangeNotifier {
  late File image;
 late  bool _loading;
  /*late */List<Map<String, dynamic>> _lowerLevels=[];
  late Map<String,dynamic> _regData ;
  /*late */Map<String, dynamic>? _currentLevel;
  late Map<String,dynamic> _regSteps;
  bool _matchedTXN =false;
  /*String _username = '';*/
  late String _otp;
  Map<String,dynamic>? get currentLevel => _currentLevel;
  bool get loading => _loading;
  List<Map<String, dynamic>> get lowerLevels => _lowerLevels;
  Map<String,dynamic> get regData => _regData;
  bool get matchedTXN => _matchedTXN;
  /*String get username => _username;*/
  String get otp => _otp;
  bool hasRegFee=false;bool hasOTP=true;
  Map<String,dynamic> get regSteps => _regSteps;
  int pageCount=1;int currentPage=0;
  Map<String, Map> setting={
    'x':{'fee':0,'otp':false},
    'y':{'fee':50,'otp':true},
    'z':{'fee':0,'otp':false},
  };
  final RegisterService _registerService = RegisterService();
  
  
  
  void onLevelChange(String level){
    /*pageCount=3;notifyListeners();*/hasRegFee=true;notifyListeners();hasOTP=true;notifyListeners();
    _currentLevel=_lowerLevels.firstWhere((l) => l['level'] == level);
    if(currentLevel!['regFee']==0){hasRegFee=false;notifyListeners();/*pageCount--;notifyListeners();*/}
    //else{pageCount++;notifyListeners();}
    if(!currentLevel!['otp']){hasOTP=false;notifyListeners();/*pageCount--;notifyListeners();*/}
    //else{pageCount++;notifyListeners();}
  }
  
  void incrementCurrentPage(){
    currentPage++;notifyListeners();
  }
  
  void fetchLevels()async {
    _loading = true;notifyListeners();
    _lowerLevels =await _registerService.fetchUserLevels();
    if(_lowerLevels.isNotEmpty){_currentLevel=_lowerLevels[0];notifyListeners();}
    _loading = false;notifyListeners();
  }
  
  void setRegData(Map<String,dynamic> user/*, String nid*/) {
    _regData = user;
    //_nidNumber = nid;
    notifyListeners();
  }

  void getOTP(/*String value*/) async{
    _otp = await _registerService.fetchOTP(regData['username']);
    notifyListeners();
  }

  void regFeeTXN(String txn, String ref) async{
    _loading = true;notifyListeners();
    _matchedTXN = await _registerService.regFeeTXN(txn,ref);
    _loading=false;notifyListeners();
  }
  /*Future<String> _uploadCloudinary(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dnyyugfjv/image/upload');
    final request =  http.MultipartRequest('POST', url)
    ..fields['upload-preset']='nid-preset'
    ..files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
        /*Provider.of<SignUpData>(context).nidImageUrl*/ return data['secure_url'];
      // });
    }  
      return '';

  }*/
  /*void registerUser(String level,String username,String fullname,int nid,int pin,String password) async {
    _loading = true;notifyListeners();
    await _registerService.register(level,username,fullname,nid,pin,password);
    _loading = false;notifyListeners();
  }*/
  /*Future<Map<String, String>> toJson() async {
    return {
      // 'image': await _uploadCloudinary(image),
      'name': _name,
      'phone': _username,
      'nid': _nidNumber,
      'password': _password,
      'pin': _pin,
    };
  }*/
}
