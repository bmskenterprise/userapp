import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/ApiProvider.dart';
import '../providers/DepositProvider.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'Toast.dart';
import 'PIN.dart';
//import '/providers/TransferProvider.dart';

class Mbank extends StatefulWidget {
  final String provider;
  const Mbank({super.key,required this.provider});
  @override
  State<Mbank> createState() => _MbankState();
}

class _MbankState extends State<Mbank> {
  final _formKey = GlobalKey<FormState>();
  bool _showNextFields = false;
   String transactionType = 'send-money';
  late Map<String, dynamic> transactionData;
  
  /*@override
  void dispose(){
    _numberController.dispose();
    super.dispose();
  }*/
         // _showNextFields = true;
      //if (value != 
        

  void _onNext(String? value) {
    setState(() {
      if(value!=null) {
        transactionType = value;
        if(!_showNextFields) {_showNextFields =true;}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiProvider>();
    final auth = context.watch<AuthProvider>(); //হলে আর false হবে না
    final deposit = context.watch<DepositProvider>();
    return /*!auth.authPrefs['accesses'].contains('migrate')?Center(child: Text('এই মুহূর্তে ব্যাল্যান্স মাইগ্রেট করার অনুমতি নেই'),): Scaffold(
      appBar: AppBar(title: Text('Add Balance')),
      body: api.loading?Center(child: CircularProgressIndicator(),):*/Stack(
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
                      title: const Text('send money'),
                      leading: Radio<String>(
                        value: 'send-money',
                        groupValue: transactionType,
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('cash in'),
                      leading: Radio<String>(
                        value: 'cash-in',
                        groupValue: transactionType,
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
                    return null;
                  },
                  onSaved: (newValue) => transactionData['recipient'] = newValue,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters:[FilteringTextInputFormatter.digitsOnly], 
                  //controller: _numberController,
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
                    transactionData['amount'] = v/*_numberController.text*/;
                  },
                ),
                SizedBox(height: 20),
                FilledButton(
                  onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if(context.read<DepositProvider>().balance['balanceType']!<transactionData['balanceType']){
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
                      if(auth.matchedPIN){
                        if(transactionType=='send-money') {await api.sendMoney/*Init*/(widget.provider,transactionData['recipient'],transactionData['amount']);}
                        else {api.cashin(widget.provider,transactionData['recipient'],transactionData['amount']); }
                        //if (res==null) Toast({'message':'কিছু একটা সমস্যা হয়েছে','success':false});return;
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
        deposit.loading?CircularProgressIndicator():SizedBox()
        ]
      //),
    );
  }
}
