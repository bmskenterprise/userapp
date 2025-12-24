import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentProvider with ChangeNotifier {
  String paymentMethod = "bank";
  String paymentStatus = "Pending";
  int _paymentAmount = 0;
  String paymentDate = "0";
  String paymentTime = "0";
  String paymentId = "0";
  String _paymentType = "";
  String paymentStatusCode = "0";
  String paymentStatusMessage = "";
  int get paymentAmount => _paymentAmount;
  String get paymentType => _paymentType;

  Future<dynamic> setPaymentInit(String balanceType,int paymentAmount)async {
    _paymentType = balanceType;
    _paymentAmount = paymentAmount;
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/bkash/payment/create'),
      headers:{'Content-Type': 'application/json'}, 
      body:jsonEncode({ 'amount': _paymentAmount, 'orderId': 1 })
    );
    if (response.statusCode==200) {
      final data=jsonDecode(response.body).data;
      return data.bkashURL;
    }
    return null;
  }

  void setPaymentmethod(String paymentmethod) {
    paymentMethod = paymentmethod;
    notifyListeners();
  }

  void setPaymentstatus(String paymentstatus) {
    
  }
}