import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
//import '../services/AuthService.dart';
import '../FullScreenLoader.dart';
//import '../util/baseURL.dart';
import '../providers/AuthProvider.dart';

class ChangePIN extends StatefulWidget {
  const ChangePIN({super.key});
  @override
  State<ChangePIN> createState() => _ChangePINState();
}


class _ChangePINState extends State<ChangePIN> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerOldPIN = TextEditingController();
  final TextEditingController _controllerNewPIN = TextEditingController();

  @override
  void dispose() {
    _controllerOldPIN.dispose();
    _controllerNewPIN.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final auth=context.watch<AuthProvider>();
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
                    controller:_controllerOldPIN,
                    decoration: InputDecoration(
                      labelText: 'Old PIN',
                      errorText: auth.asyncError,
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _controllerNewPIN,
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
                          auth.validatePIN(_controllerOldPIN.text);
                          if(auth.matchedPIN){context.read<AuthProvider>().changePIN(_controllerNewPIN.text);}
                      }//);
                      /*final response=await http.get(Uri.parse(ApiConstants.changePassword));
                      if(response.statusCode==200){
                        setState((){
                        });
                      }*/
                    },
                    child: Text('Change PIN'),
                  )
                ]
              ),
            )
      ),
            auth.loading ? FullScreenLoader() : const SizedBox()

          ]
    ),
    );
  }
}