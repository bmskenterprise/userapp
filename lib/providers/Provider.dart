import 'package:flutter/material.dart';

class Provider with ChangeNotifier {
  

  Future payBill() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/history'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        /*setState(() {
          _balances = data.map((json) => Balance.fromJson(json)).toList();
          _isLoading = false;
        });*/
      } else {
        throw Exception('Failed to load balance history');
      }
    } catch (e) {
      print(e);
    }fi
  }
}