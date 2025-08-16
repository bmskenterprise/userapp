import 'package:bmsk_userapp/providers/DepositProvider.dart';
import 'package:flutter/material.dart';
import 'package:bmsk_userapp/PIN.dart';
import 'package:flutter/services.dart';
import 'package:bmsk_userapp/Toast.dart';
//import 'package:bmsk_userapp/providers/DepositProvider.dart';
//import 'package:bmsk_userapp/util/baseURL.dart';
//import 'package:bmsk_userapp/payment/PaymentProvider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Manual extends StatefulWidget {
  const Manual({super.key});
  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  final TextEditingController _controllerTXNID =TextEditingController();
  final TextEditingController _controllerRef =TextEditingController();

  void _copyText(String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    Toast({'message':'কপি হয়েছে','success':true});
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List depositData=context.read<DepositProvider>().depositData;
      if(!context.read<DepositProvider>().hasError){
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Add Balance!"),
              content: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:depositData.map((e) => Row(children:[Text('${e['name']}: '),GestureDetector(onTap:()=>_copyText(e['account']),child:Text(e['account']))])).toList(),
              ),
              actions: [
                TextButton(
                  child: Text("ok"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<DepositProvider>().loading?Center(child:CircularProgressIndicator(),) :context.watch<DepositProvider>().hasError?Center(child:Text('something went wrong')): Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _controllerTXNID,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                border: OutlineInputBorder(),
              ),
            ),SizedBox(height: 40,),
            TextFormField(
              controller: _controllerRef,
              decoration: InputDecoration(
                labelText: 'Ref ',
                border: OutlineInputBorder(),
              ),
            ),SizedBox(height: 40,),
            FilledButton(
              onPressed: (){
                if(_controllerTXNID.text.isNotEmpty){
                  PIN();
                  if(context.watch<AuthProvider>().matchedPIN){
                    context.read<DepositProvider>().depositByTxnId(_controllerTXNID.text,_controllerRef.text);
                  }
                }
              },
              child: Text('Next')
            )
          ],
        )
      ),
    );
  }
}