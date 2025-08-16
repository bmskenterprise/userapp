import 'package:bmsk_userapp/services/TopupService.dart';
import 'package:flutter/material.dart';

class TopupProvider with ChangeNotifier{
  topup(String recipient, String opt, int amount){
    return TopupService().topup;
  }
}