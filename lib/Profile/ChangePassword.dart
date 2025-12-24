import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../FullScreenLoader.dart';
//import '../widgets/Toast.dart';
import '../providers/AuthProvider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}


class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _controllerOldPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  @override
  void dispose() {
    _controllerOldPassword.dispose();
    _controllerNewPassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
      children: [
      Padding(
        padding: EdgeInsets.all(40),
        child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _controllerOldPassword,
              decoration: InputDecoration(
                labelText: 'Old Password',
                errorText: context.watch<AuthProvider>().asyncError,
                border: OutlineInputBorder()
              ),
            ),
            TextFormField(
              controller: _controllerNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder()
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder()
              ),
            ),
            ElevatedButton(
              onPressed: ()async{
                /*Map<String, dynamic> res=await */context.read<AuthProvider>().changePassword(_controllerOldPassword.text.trim(), _controllerNewPassword.text.trim());
                /*if(res['success']){
                  Toast(res);
                  Navigator.pop(context);
                }else{
                  Toast(res);
                }*/
              },
              child: Text('Change Password'),
            )
          ]
        ),
      )),
            context.watch<AuthProvider>().loading ? FullScreenLoader() : const SizedBox()
      ])
    );
  }

}