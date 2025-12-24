import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/DepositProvider.dart';
import '../providers/RegisterProvider.dart';
//import '/util/baseURL.dart';
//import '/payment/PaymentProvider.dart';
import 'VerifyMobileNumber.dart';
import '../widgets/Toast.dart';
import '../Index.dart';
//import 'package:http/http.dart' as http;

class RegFee extends StatefulWidget {
  const RegFee({super.key});
  @override
  State<RegFee> createState() => _RegFeeState();
}

class _RegFeeState extends State<RegFee> {
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
      /*List depositData=*/context.read<DepositProvider>().getMbanks();
      if(!context.read<DepositProvider>().hasError){
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Add Balance!"),
              content: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:context.watch<DepositProvider>().mbanks.map((e) => Row(children:[Text('${e['name']}: '),GestureDetector(onTap:()=>_copyText(e['account']),child:Text(e['account']))])).toList(),
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
  void dispose() {
    _controllerTXNID.dispose();
    _controllerRef.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deposit=context.watch<DepositProvider>();
    final reg=context.watch<RegisterProvider>();
    return deposit.loading?Center(child:CircularProgressIndicator(),) :deposit.hasError?Center(child:Text('something went wrong')): Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        child: Column(
          children: [
            Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:deposit.mbanks.map((e) => Row(children:[Text('${e['name']}: '),GestureDetector(onTap:()=>_copyText(e['account']),child:Text(e['account']))])).toList(),
            ),SizedBox(height: 100,),
            TextFormField(
              controller: _controllerTXNID,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                border: OutlineInputBorder(),
              ),
            ),SizedBox(height: 40,),
            /*TextFormField(
              controller: _controllerRef,
              decoration: InputDecoration(
                labelText: 'Ref ',
                border: OutlineInputBorder(),
              ),
            ),*/SizedBox(height: 40,),
            FilledButton(
              onPressed: (){
                if(_controllerTXNID.text.isNotEmpty){
                  context.read<RegisterProvider>().regFeeTXN(_controllerTXNID.text,_controllerRef.text);;
                  if(reg.matchedTXN){
                    if(reg.hasOTP){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyMobileNumber()));return;
                    }
                    context.read<AuthProvider>().register(reg.regData);
                    if(context.watch<AuthProvider>().loggedIn){Navigator.push(context, MaterialPageRoute(builder: (context)=>Index()));}
                  }
                }
              },
              child: Text(reg.hasOTP?'Next':'Register')
            )
          ],
        )
      ),
    );
  }
}