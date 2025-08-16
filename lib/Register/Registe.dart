//import 'dart:convert';
import 'package:bmsk_userapp/Register/RegisterForm.dart';
//import 'package:bmsk_userapp/Register/UploadNIDScreen.dart';
import 'package:bmsk_userapp/Register/VerifyPhoneScreen.dart';
//import 'package:bmsk_userapp/providers/SignUpData.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:provider/provider.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _controller = PageController();
  Map<String, dynamic> userData = {};
  late List<Widget> _pages;
  int _currentPage = 0;
  void next() {
      if (_currentPage < _pages.length - 1) {
        setState(() {
          _currentPage++;
        });
        _controller.animateToPage(_currentPage, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        // Registration complete
      }
      }

@override
  void initState() {
    super.initState();
    _pages = [
      // UploadNIDScreen(nextHandler: next),
      RegisterFormScreen(nextHandler: next),
      VerifyPhoneScreen(nextHandler: next),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(), // হাত দিয়ে scroll বন্ধ
        children: _pages,
      ),
      /*bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:[ElevatedButton(
          child: Text("Next"),
          onPressed: () {
            if (_currentPage < _pages.length - 1) {
              setState(() {
                _currentPage++;
              });
              _controller.animateToPage(_currentPage,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            } else {
              // Registration complete
            }
          },
      )]
      ),*/
    );
  }
}
