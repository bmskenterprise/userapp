import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../util/baseURL.dart';
import '../services/AppService.dart';

class AppProvider with ChangeNotifier {
  final AppService _appService = AppService();
  
  final IO.Socket _socket = IO.io(ApiConstants.server, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
  });
  bool _isInternetConnected = true;
  double _dragOffset =0.0;
  int _indexBottomNavBar =0;
  bool _isDarkTheme = true;
  bool _initFeedbackForm=false;
  
  bool get isInternetConnected => _isInternetConnected;
  IO.Socket get socket => _socket;
  bool get isDarkTheme => _isDarkTheme;
  double get dragOffset => _dragOffset;
  int get indexBottomNavBar => _indexBottomNavBar;
  bool get initFeedbackForm => _initFeedbackForm;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void checkInternetStatus() {
    InternetConnection().onStatusChange.listen((status) {
      bool current = status==InternetStatus.connected;
      if(current!=_isInternetConnected){
        _isInternetConnected=current;notifyListeners();
      }
    });
  }
  
  void setDragOffset(double offset) {
    _dragOffset = offset;
  }
  
  void setCurrentBottomNavBarIndex(int index) {
    _indexBottomNavBar = index;notifyListeners();
  }
  
  void setFeedbackFormState(bool b) {
    _initFeedbackForm = b;notifyListeners();
  }
}