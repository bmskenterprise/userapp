import 'package:bmsk_userapp/FullScreenLoader.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  
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
              controller: _oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Old Password',
                errorText: context.watch<AuthProvider>().asyncError,
                border: OutlineInputBorder()
              ),
            ),
            TextFormField(
              controller: _newPasswordController,
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
                Map<String, dynamic> res=await context.read<AuthProvider>().changePassword(_oldPasswordController.text.trim(), _newPasswordController.text.trim());
                if(res['success']){
                  Toast(res);
                  Navigator.pop(context);
                }else{
                  Toast(res);
                }
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