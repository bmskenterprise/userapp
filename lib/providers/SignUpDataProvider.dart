import 'dart:io';
import 'package:flutter/material.dart';


class SignUpData with ChangeNotifier {
  late File image;
  String _name = '';
  String _username = '';
  String _nidNumber='';
  String _password = '';
  String _pin='';
  String get name => _name;
  String get username => _username;
  String get nidNumber => _nidNumber;
  String get password => _password;
  String get pin => _pin;

  void updateNIDData(String name, String nid) {
    _name = name;
    _nidNumber = nid;
    notifyListeners();
  }

  void updateUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void updateCredentials(String password, String pin) {
    _password = password;
    _pin = pin;
    notifyListeners();
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

  Future<Map<String, String>> toJson() async {
    return {
      // 'image': await _uploadCloudinary(image),
      'name': _name,
      'phone': _username,
      'nid': _nidNumber,
      'password': _password,
      'pin': _pin,
    };
  }
}
