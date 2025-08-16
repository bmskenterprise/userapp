import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
 
 
Future<bool?> Toast(Map<String, dynamic> messageState) {
    return Fluttertoast.showToast(
        msg: messageState['message'],
        // toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: messageState['success']? Colors.green : Colors.red,
        fontSize: 16.0
    );
}

   


