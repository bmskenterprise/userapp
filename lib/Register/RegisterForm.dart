import 'dart:convert';
import 'package:bmsk_userapp/providers/SignUpDataProvider.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:myapp/CustomField.dart';
// import 'package:myapp/CustomField.dart';


class RegisterFormScreen extends StatefulWidget {
  final Function nextHandler;
  const RegisterFormScreen({super.key,required this.nextHandler});
  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}


class _RegisterFormScreenState extends State<RegisterFormScreen> {
  late TextEditingController _controllerName; 
  late TextEditingController _controllerNIDNumber; 
  @override
  void initState() {
    _controllerName=TextEditingController(text: Provider.of<SignUpData>(context, listen: false).name);
    _controllerNIDNumber = TextEditingController(text: Provider.of<SignUpData>(context, listen: false).nidNumber);
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Map userData={};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*TextFormField(
              decoration: InputDecoration(
                label: Text(' username'),
                prefixIcon: Icon(Icons.person)
              ),
              validator: (value) {
                if(value==null || value.isEmpty){
                  return 'Enter a valid username';
                }
                if (!(RegExp(r'^[a-zA-Z0-9]{4,15}$').hasMatch(value!))) {
                  return 'username only include alpha, number';
                }
                return null;
              },
              onSaved: (value) {
                userData['username'] = value;
              },
            ),*/
            TextFormField(
              decoration: InputDecoration(
                label: Text('user name'),
                prefixIcon: Icon(Icons.phone)
              ),
              validator: (value) {
                if(value==null || value.isEmpty){
                  return 'Enter a phone number';
                }
                if (!(RegExp(r'^01[3-9]\d{8}$').hasMatch(value))) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
              onSaved: (value) {
                userData['username'] = value;
              },
            ),
            TextFormField(
              controller: TextEditingController(text: Provider.of<SignUpData>(context, listen: false).name),
              decoration: InputDecoration(label: Text('Full Name')),
              validator: (value) {
                if(value==null || value.isEmpty){return 'enter ';}
                if(value.length<4 || value.length>50){return 'name must be greater than 3 character and less than 50';}
                if (!(RegExp(r'^(?=.*[a-zA-Z]{3,})[a-zA-Z\s]$').hasMatch(value))) {return 'Enter a valid name';}
                return null;
                  
                
                  
                
                  
                
              },
              onSaved: (value){
                userData['name'] = value;
              },
            ),

            TextFormField(
              controller: _controllerNIDNumber,
              readOnly: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(label: Text('enter NID number')),
              validator: (value) {
                if(value==null || value.isEmpty){return 'enter a NID';}
                if(value.length<4 || value.length>6){return 'must be greater than 4 character and less than 6';}
                if (!(RegExp(r'^\d{4,6}$').hasMatch(value))) {}
                return null;
                  
                
                  
                
              },
              onSaved: (value) {
                userData['nid'] = value;
              },
            ),

            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                label: Text('pin password'),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: _obscureText?Icon(Icons.visibility):Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                    //});
                  }
                )
              ),
              validator: (value) {
                if(value==null || value.isEmpty){return 'enter a password';}
                if(value.length<8 || value.length>32){return 'must be greater than 8 character and less than 32';}
                if (!(RegExp(r'[!@#$%^&*(),.?":{}|<>a-zA-Z0-9]{8,32}').hasMatch(value))) {return 'Enter a valid password ';}
                return null;
                  
                
                  
                
                  
                
              },
              onSaved: (value) {
                userData['password'] = value;
              },
            ),

            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(label: Text('set pin number')),
              validator: (value) {
                if(value==null || value.isEmpty){return 'enter a pin';}
                if(value.length<4 || value.length>6){return 'must be greater than 4 character and less than 6';}
                if (!(RegExp(r'^\d{4,6}$').hasMatch(value))) {}
                return null;
                  
                
                  
                
              },
              onSaved: (value) {
                userData['pin'] = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await getOTP(userData['username']);
                  //Navigator.pushNamed(context, '/home',arguments: {'username':username,'pin':pin});
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future getOTP(String username) async {
    try {
      final uri = Uri.parse(ApiConstants.verifyUser['url']);
      final response = await http.post(uri,headers:{'Content-Type':'application/json'},body: jsonEncode({'username':username}));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
        if (response.statusCode == 400) {
          Toast({'message':ApiConstants.verifyUser['client-err'], 'success':false});
        }
        if (response.statusCode == 500) {
          Toast({'message':ApiConstants.verifyUser['server-err'], 'success':false});
        }
        else {
          throw Exception('Failed to register');
        }
    } catch (e) {
      print('err');
    }
  }
  //}
  @override
  void dispose() {
    _controllerName.dispose(); // Always dispose controllers to avoid memory leaks
     _controllerNIDNumber.dispose();
    super.dispose();
  }
}
