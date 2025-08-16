import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';

class UploadPic extends StatefulWidget {
  final Function nextHandler;
  const UploadPic({super.key, required this.nextHandler});

  @override
  State<UploadPic> createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {
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
  
    File? _image;
  String _extractedText = '';
  bool _isProcessing = false;
  Future<XFile> compress(File image)async{
    final compressedImage= await FlutterImageCompress.compressAndGetFile(image.path, image.path, quality: 90);
  }

  Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
     if(pickedImage != null) {
      setState (() {
        _image= File(pickedImage.path);
      });
    }
      _performOCR(_image!);
  }
  
  Future<void> _performOCR(File imageFile) async {
    const List<String> keywords = ["জাতীয় পরিচয়পত্র", "গণপ্রজাতন্ত্রী বাংলাদেশ সরকার","National ID", "People's Republic of Bangladesh"];
    setState(() {
      _isProcessing = true;
    });

    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
      _extractedText = recognizedText.text;
List<String> lines = _extractedText.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    bool isValid = keywords.every(keyword => lines.contains(keyword));
if(isValid) nextHandle();
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [Text(''),
          GestureDetector(
            onTap: ,
            child: image != null?Image.file(image):Image.asset(''),
          )],
      ),
    );
  }
}