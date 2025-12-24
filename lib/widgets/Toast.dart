import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
 
 
Future<bool?> Toast(Map<String, dynamic> messageState) {
    return Fluttertoast.showToast(
        msg: messageState['message'],
        // toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: messageState['success']? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}

   


