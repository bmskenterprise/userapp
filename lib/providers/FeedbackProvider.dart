import 'package:flutter/material.dart';
import 'package:bmsk_userapp/services/FeedbackService.dart';

class FeedbackProvider with ChangeNotifier {
  final _feedbackService = FeedbackService();
  bool _loading = false;
  bool _initForm = false;
  bool get initForm => _initForm;
  bool get loading => _loading;
  late List _items;
  List get items => _items;

  Future<List> getFeedbacks() async{
    _loading = true;notifyListeners();
    _items = await _feedbackService.fetchFeedbacks();
    _loading = false;notifyListeners();
    return _items;
  }

  Future<Map> setFeedback(String subject, String description) async {
    _loading = true;notifyListeners();
    final success = await _feedbackService.addFeedback(subject, description);
    if (success) {
        _items.add({"subject": subject, "description": description});
        _loading=false;notifyListeners();
      return {'message':'Feedback added successfully', 'success':true};
    }
    _loading = false;notifyListeners();
    return {'message':'failed added feedback', 'success':false};
  }

  void setForm(bool b){
    _initForm=b;notifyListeners();
  }
}