import 'package:flutter/material.dart';
import 'package:bmsk_userapp/PIN.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/WebView.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:bmsk_userapp/payment/PaymentProvider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class Payment extends StatefulWidget {
  const Payment({super.key});
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Box box;
  bool loading=true;
  final _formKey = GlobalKey<FormState>();
  bool _showNextFields = false;
  final TextEditingController _controllerNumber = TextEditingController();
  Map<String, dynamic> paymentData = {};Map? depositData;


  void _onNext(String? value) {
    setState(() {
      if (value != null) {
        paymentData['balanceType'] = value;
        // একবার true হলে আর false হবে না
        if (!_showNextFields) {
          _showNextFields = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
                        groupValue: paymentData['balanceType'],
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('bank '),
                      leading: Radio<String>(
                        value: 'bank',
                        groupValue: paymentData['balanceType'],
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                ],
              ),
              if (_showNextFields) ...[
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _controllerNumber,
                  decoration: InputDecoration(label: Text('Amount')),
                  validator: (value) {
                    final number = int.tryParse(value!);
                    if (value.isEmpty) {return 'Please enter some amount';}
                    if (number == null) {return 'Please enter a valid number';}
                    if (number<depositData?['min'] || number>depositData?['max']) {return 'Number must be > ${depositData?['min']} and < ${depositData?['max']}';}
                    return null;
                      
                    //}
                      
                    //}
                      
                    //}
                  },
                  onSaved: (v) {
                    paymentData['amount'] = _controllerNumber.text;
                  },
                ),
                SizedBox(height: 20),
                FilledButton(
                  onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();showModalBottomSheet(
                        context: context, 
                        builder: (context){
                          return ChangeNotifierProvider.value(
                            value: Provider.of<AuthProvider>(context),
                            child: PIN(/*proceed: nextStep,*/)
                          );
                        }
                      );
                      if(context.watch<AuthProvider>().matchedPIN){
                        final res=await context.read<PaymentProvider>().setPaymentInit(paymentData['balanceType'],paymentData['amount']);
                        if (res==null) {Toast({'message':'কিছু একটা সমস্যা হয়েছে','success':false});return;}
                          
                        //}
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebView(url: res)));
                      }
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ],
          ),
        ),
      ),
    );;
  }
}