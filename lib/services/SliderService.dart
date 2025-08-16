import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bmsk_userapp/util/baseURL.dart';

class SliderService {
  
  Future<List<String>> fetchSliderURLs() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.sliderURL),
      );
      if (response.statusCode == 200) {
        /*List data =*/return jsonDecode(response.body);
        /*setState(() {
          _balances = data.map((json) => Balance.fromJson(json)).toList();
          _isLoading = false;
        });*/
      } else {
        throw Exception('Failed to load balance history');
      }
    } catch (e) {
      return [];
    }//fin
  }
}