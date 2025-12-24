import 'package:flutter/material.dart';
import '../services/ApiService.dart';
//import '../models/Drive.dart';
//import '../models/Regular.dart';

class ApiProvider with ChangeNotifier{
  final ApiService _apiService=ApiService();
  bool _loading = false;
  List<String>? _sliderImages= [];
  List<String>? get sliderImages => _sliderImages;
  List<Map<String,String>> _mbanks =[];
  List<Map<String,String>> get mbanks=> _mbanks;
  List<String> _bankNames =[];
  List _feedbacks =[];// _drives;
  List<Map<String,String>> _contacts =[];
  //late Map<String, List<Regular>> _regulars;
  //List<String> _imageURLs =[];
  
  bool get loading => _loading;
  List<String> get bankNames => _bankNames;
  //List<String> get imageURLs => _imageURLs;
  List<Map<String,String>> get contacts => _contacts;
  List get feedbacks => _feedbacks;


  /*Future<void> fetchDrivePacks(String opt) async {
    if(_drives.containsKey(opt)) {
      _currentDrivePacks=_drives[opt]!;
    }else {_currentDrivePacks =await _apiService.fetchDrivepacks(opt);_drives[opt]=_currentDrivePacks;}
  }
  Future<void> fetchRegularPacks(String opt)async{
    if(_regulars.containsKey(opt)) {_currentRegularPacks=_regulars[opt]!;}
    else {_currentRegularPacks=await _apiService.fetchRegularpacks(opt);_regulars[opt]=_currentRegularPacks;}
  }*/
  Future<void> sendMoney(String provider,String recipient,int amount)async{
    /*_imageURLs=*/await _apiService.sendMoney(provider,recipient,amount);
  }
  Future<bool> cashin(String provider,String recipient,int amount/*, String price, int amount, String billMonth*/) async {
    _loading = true;notifyListeners();
    bool status=await _apiService.cashin(provider,recipient,amount /*, price, amount, billMonth*/);
    _loading = false;notifyListeners();return status;
  }
         
  void getSliderImages() async{
    _loading = true;notifyListeners();
    _sliderImages = await _apiService.fetchSliderImages();
    _loading = false;notifyListeners(); //200) _bankNames=jsonDecode(response.body);
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
  void getContacts()async{
    _loading=true;notifyListeners();
      _contacts = await _apiService.fetchContacts();
      _loading=false;notifyListeners();
  }
  void getBankNames()async{
    _loading=true;notifyListeners();
       _bankNames= await _apiService.fetchBankNames();
      _loading=false;notifyListeners();
  }
  void getMbanks() async{
    _mbanks=await _apiService.fetchMbanks();notifyListeners();
  }
  
  void getFeedbacks() async{
    _loading = true;notifyListeners();
    _feedbacks = await _apiService.fetchFeedbacks();
    _loading = false;notifyListeners();
  }
  
  void addFeedback(String d) async{
    _loading = true;notifyListeners();
    await _apiService.addFeedback(d);
    _loading = false;notifyListeners();
  }
}