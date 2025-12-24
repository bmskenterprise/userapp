import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/DepositProvider.dart';
import 'widgets/PIN.dart';
//import 'widgets/Toast.dart';
import 'Checkout.dart';
//import '/util/baseURL.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:http/http.dart' as http;


class PaymentGatewayFragment extends StatefulWidget {
  const PaymentGatewayFragment({super.key});
  @override
  State<PaymentGatewayFragment> createState() => _PaymentGatewayFragmentState();
}

class _PaymentGatewayFragmentState extends State<PaymentGatewayFragment> {
  //late Box box;
  bool loading=true;
  final _formKey = GlobalKey<FormState>();
  bool _showNextFields = false;
  //final TextEditingController _controllerNumber = TextEditingController();
  Map<String, dynamic> paymentData = {};//Map? depositData;


  void _onNext(String? value) {
    setState(() {
      if (value != null) {
        paymentData['balanceType'] = value;
        if (!_showNextFields) {
          _showNextFields = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final depositRange = context.watch<DepositProvider>().depositRange; //       না
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
                      title: const Text('Topup'),
                      leading: Radio<String>(
                        value: 'topup',
                        groupValue: paymentData['balanceType'],
                        onChanged: _onNext,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Drive'),
                      leading: Radio<String>(
                        value:'drive',
                        groupValue: paymentData['balanceType'],
                        onChanged: _onNext,
                      )
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Bank '),
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
                  //controller: _controllerNumber,
                  decoration: InputDecoration(label: Text('Amount')),
                  validator: (value) {
                    final number = int.tryParse(value!);
                    final min = depositRange[paymentData['balanceType']]?['min'];
                    final max= depositRange[paymentData['balanceType']]?['max'];
                    if (value.isEmpty) {return 'Please enter some amount';}
                    if(number==null) {return 'Please enter a valid number';}
                    if(number<min! || number>max!) {return 'Number must be > $min and < $max';}
                    return null;
                      
                    //}
                      
                    //}
                      
                    //}
                  },
                  onSaved: (v) {
                    paymentData['amount'] = v;
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
                        /*final res=await */context.read<DepositProvider>().setDepositData({'balanceType':paymentData['balanceType'],'amount':paymentData['amount']});
                        //if (res==null) {Toast({'message':'কিছু একটা সমস্যা হয়েছে','success':false});return;}
                          
                        //}
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Checkout(/*url: res*/)));
                      }
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ],
          ),
        ),
      
    );
  }
}