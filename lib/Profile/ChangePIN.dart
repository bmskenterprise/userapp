import 'package:bmsk_userapp/AuthService.dart';
import 'package:bmsk_userapp/FullScreenLoader.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  // bool? requesting=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Old PIN',
                      errorText: context.watch<AuthProvider>().asyncError,
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _pinController,
                    decoration: InputDecoration(
                      labelText: 'New PIN',
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirm PIN',
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: ()async{
                      if(_formKey.currentState!.validate()){
                          AuthProvider().matchPIN(_pinController);
                      }//);
                      final response=await http.get(Uri.parse(ApiConstants.changePassword));
                      if(response.statusCode==200){
                        setState((){
                          requesting=false;
                        });
                      }
                    },
                    child: Text('Change PIN'),
                  )
                ]
              ),
            )
      ),
            context.watch<AuthProvider>().loading ? FullScreenLoader() : const SizedBox()

          ]
    ),
    );
  }
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}