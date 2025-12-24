import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/DepositProvider.dart';
import 'widgets/PIN.dart';
import 'widgets/Toast.dart';
//import 'providers/DepositProvider.dart';
//import 'util/baseURL.dart';
//import '/payment/PaymentProvider.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:http/http.dart' as http;

class PaymentManualFragment extends StatefulWidget {
  const PaymentManualFragment({super.key});
  @override
  State<PaymentManualFragment> createState() => _PaymentManualStateFragment();
}

class _PaymentManualStateFragment extends State<PaymentManualFragment> {
  final TextEditingController _controllerTXNID =TextEditingController();
  final TextEditingController _controllerRef =TextEditingController();
  /*Map<String,dynamic>*/ String balanceType = '';Map? depositData;
  bool _next=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Map> mbanks=context.read<DepositProvider>().mbanks;
      if(!context.read<DepositProvider>().hasError){
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Add Balance!"),
              content: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:mbanks.map((e) => Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children:[Text('${e['name']}: '),GestureDetector(onTap:()=>_copyText(e['account']),child:Text(e['account']))]
                )).toList(),
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

  void _copyText(String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    Toast({'message':'কপি হয়েছে','success':true});
  }

  void _onNext(String? value) {
    setState(() {
      if (value != null) {
        balanceType = value;
        // একবার true হলে আর false হবে না
        if (!_next) {
          _next = true;
        }
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('top up'),
                      leading: Radio<String>(
                        value: 'topup',
                        groupValue: balanceType,
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('drive'),
                      leading: Radio<String>(
                        value: 'drive',
                        groupValue: balanceType,
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('bank '),
                      leading: Radio<String>(
                        value: 'bank',
                        groupValue: balanceType,
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                ],
              ),
            if(_next)...[
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
                      context.read<DepositProvider>().depositByTxnId(_controllerTXNID.text,balanceType,_controllerRef.text);
                    }
                  }
                },
                child: Text('Next')
              )
            ]
          ],
        )
      ),
    );
  }
}