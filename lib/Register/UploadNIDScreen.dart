import 'dart:convert';
import 'dart:io';

import 'package:bmsk_userapp/providers/SignUpDataProvider.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadNIDScreen extends StatefulWidget {
  final Function nextHandler;
  const UploadNIDScreen({super.key, required this.nextHandler});

  @override
  State<UploadNIDScreen> createState() => _UploadNIDScreenState();
}

class _UploadNIDScreenState extends State<UploadNIDScreen> {
    File? _image;
  String _extractedText = '';
  bool _isProcessing = false;
  Map nidData={};

  Future next(BuildContext context) async{
    Map data = await _OCR(_image!);nidData=data['nidData'];
    if(!data['isValid']){
      Toast({'message':'জাতীয় পরিচয়পত্রের সামনের অংশের সম্পূর্ণ এবং পরিস্কার ছবি দিন ','success':false},context);
      return;
    }
    try {
      final response=await http.post(Uri.parse('${ApiConstants.baseUrl}/api/nid'),body: {'nidNumber':nidData['nidNumber']});
      if(response.statusCode==200){
        if(jsonDecode(response.body).matched){
          Toast({'message': 'অন্য NID দিয়ে চেষ্টা করুন','success':false}, context);
          return;
        }
      }else{
        Toast({'message':'ভেরিফিকেশন ব্যর্থ, আবার চেষ্টা করুন','success':false}, context);
      }
    } catch (e) {
      Toast({'message':'ভেরিফিকেশন ব্যর্থ, আবার চেষ্টা করুন','success':false}, context);
    }
    final signUpData = Provider.of<SignUpData>(context, listen: false);
    signUpData.updateNIDData(nidData['nidName'], nidData['nidNumber']);
     widget.nextHandler(/*data: nidData\*/);
  }

  Future<Map<String, dynamic>> _OCR(File imageFile) async {
    Map<String, dynamic> nidData={};
    const List<String> keywords = ["জাতীয় পরিচয়", "গণপ্রজাতন্ত্রী বাংলাদেশ সরকার","National ID", "People's Republic of Bangladesh"];
    final patternNIDNumber=RegExp(r'^(NID|ID)\s+[nN][oO][:.]?\s+(\d{13})');
    final patternNIDName=RegExp(r'^(Name|NAME)\s+[:.]?\s+(.*)$');
    late RegExpMatch? matchNIDName;late RegExpMatch? matchNIDNumber;
    setState(() {
      _isProcessing = true;
    });

    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    setState(() {
      _isProcessing = false;
    });
      _extractedText = recognizedText.text;
List<String> lines = _extractedText.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
  for (String line in lines) {
    if (patternNIDNumber.hasMatch(line)) {
    matchNIDName=patternNIDName.firstMatch(line);
    }
  }

  for (String line in lines) {
    if (patternNIDNumber.hasMatch(line)) {
    matchNIDNumber=patternNIDNumber.firstMatch(line);
    }
  }

    bool isValid = keywords.every((keyword) => lines.contains(keyword)) && matchNIDNumber!=null && matchNIDName!=null;
    //final matchNIDNumber=patternNIDNumber.firstMatch(lines[lines.length-1]);
    if(isValid){
      nidData['nidName']=matchNIDName.group(2)!;
      nidData['nidNumber']=matchNIDNumber.group(2)!;
     }
    return {'isValid':isValid, 'nidData':nidData};
  }

  dialog (BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upload Image'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
              child: Text('Gallery'),
            )
          ]
        )
    );
  }
  
  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState (() {
        _image= File(pickedImage.path);
      });
    } /*else {
      return null;
    }*/
  }
  
  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(''),
                GestureDetector(
                  onTap: dialog(context),
                  child: AspectRatio(
                    aspectRatio: 43/27,
                    child: _image!=null?Image.file(_image!):Image.asset('1faa.png'),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ElevatedButton(onPressed: _image!=null?(){next(context);}:null, child: Text('Next'))]
          )
          /*Text(''),
          GestureDetector(
            onTap: ,
            child: Image.file(image),
          ),*/
        ],
      ),
    );
  }
}