import 'package:bmsk_userapp/PIN.dart';
import 'package:bmsk_userapp/providers/TransferProvider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});
  @override
  State<SendScreen> createState() => _SendScreenState();
}
  

class _SendScreenState extends State<SendScreen> {
  late Box box;
  final _formKey = GlobalKey<FormState>();
  bool _showNextFields = false;
  final TextEditingController _numberController = TextEditingController();
  late Map<String, dynamic> transferData;
  
  @override
  void initState(){
    super.initState();
  }

  void _onNext(String? value) {
    setState(() {
      if (value != null) {
        transferData['balanceType'] = value;
        // একবার true হলে আর false হবে না
        if (!_showNextFields) {
          _showNextFields = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return box.get('services').contains('deposit')?Center(child: Text('এই মুহূর্তে  করার অনুমতি নেই'),): Scaffold(
      appBar: AppBar(title: Text('Add Balance')),
      body: loading?Center(child: CircularProgressIndicator(),):Stack(
        children:[Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*DropdownButtonFormField(
              decoration: InputDecoration(label: Text('Balance Type')),
              items: items,
              onChanged: (value){
                setState(() {
                    balanceType = value;
                  }
                )
              }
            )*/
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('top up'),
                      leading: Radio<String>(
                        value: 'top',
                        groupValue: transferData['balanceType'],
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('bank '),
                      leading: Radio<String>(
                        value: 'bank',
                        groupValue: transferData['balanceType'],
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                ],
              ),
              if (_showNextFields) ...[
                SizedBox(height: 20),
                TextFormField(
                  decoration:InputDecoration(label: Text('username')),    
                  keyboardType:TextInputType.numberWithOptions(decimal: false),  
                  inputFormatters:[FilteringTextInputFormatter.digitsOnly],    
                  validator: (value) {
                    if(value!.isEmpty) return 'Please enter a username';
                    //if()
                  },
                  onSaved: (newValue) => transferData['recipient'] = newValue,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters:[FilteringTextInputFormatter.digitsOnly], 
                  controller: _numberController,
                  decoration: InputDecoration(label: Text('Amount')),
                  validator: (value) {
                    final number = int.tryParse(value!);
                    if (value.isEmpty) return 'Please enter some amount';
                    if (number == null) return 'Please enter a valid amount';
                    /*if (number<depositData?['min'] || number>depositData?['max']) {
                      return 'Number must be > ${depositData?['min']} and < ${depositData?['max']}';
                    }*/
                    return null;
                  },
                  onSaved: (v) {
                    transferData['amount'] = _numberController.text;
                  },
                ),
                SizedBox(height: 20),
                FilledButton(
                  onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if(context.read<AuthProvider>().balance['balanceType']!<transferData['balanceType']){
                        Toast({'message':'পর্যাপ্ত ব্যাল্যান্স নেই','success':false});return;
                      }
                      showModalBottomSheet(
                        context: context, 
                        builder: (context){
                          return ChangeNotifierProvider.value(
                            value: Provider.of<AuthProvider>(context),
                            child: PIN(/*proceed: nextStep,*/)
                          );
                        }
                      );
                      if(context.watch<AuthProvider>().matchedPIN){
                        final res=await context.read<TransferProvider>().setTransferInit(transferData['recipient'],transferData['balanceType'],transferData['amount']);
                        if (res==null) Toast({'message':'কিছু একটা সমস্যা হয়েছে','success':false});return;
                          
                        //}
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebView(url: res)));
                      }
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ],
          ),
          )),
        context.read<TransferProvider>().loading?CircularProgressIndicator():SizedBox()
        ])
      //),
    );
  }
}
