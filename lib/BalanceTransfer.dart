import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/AppProvider.dart';
import 'providers/DepositProvider.dart';
//import 'providers/TransferProvider.dart';
import 'widgets/Offline.dart';
import 'widgets/PIN.dart';
import 'widgets/Toast.dart';
import 'widgets/CircleFill.dart';

class BalanceTransfer extends StatefulWidget {
  const BalanceTransfer({super.key});
  @override
  State<BalanceTransfer> createState() => _BalanceTransferState();
}

class _BalanceTransferState extends State<BalanceTransfer> {
  //bool loading=true;
  final _formKey = GlobalKey<FormState>();
  bool _showNextFields = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();final TextEditingController _typeController=TextEditingController();
  Map<String, dynamic> transferData = {};

  @override
  void initState() {
    super.initState(); //transferInfo();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Welcome!"),
            content: Text("You navigated to the second screen."),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _amountController.dispose();
  }
  void transfer (String user, String type, int amount) async {
      bool status=await context.read<DepositProvider>().transfer(transferData['user'],transferData['balanceType'], transferData['amount']);
      if(status) context.read<AuthProvider>().disablePINConnection();
    }
  void _onNext(String? value) {
    setState(() {
      if(value!=null) {
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
    final deposit = context.watch<DepositProvider>();
    final isInternetConnected = context.watch<AppProvider>().isInternetConnected;
    final auth=context.watch<AuthProvider>();
    final balance=deposit.balance;
    return !(auth.authPrefs['accesses']??[]).contains('transfer')?Center(child:Text('এই মুহূর্তে ব্যাল্যান্স ট্রান্সফার করার অনুমতি নেই')):!isInternetConnected?Offline():Scaffold(
      appBar: AppBar(title: Text('Transfer Balance')),
      body:
          deposit.loading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
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
                                      title: const Text('drive'),
                                      leading: Radio<String>(
                                        value: 'drive',
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
                                TextFormField(
                                  // keyboardType: TextInputType.number,
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    label: Text('username'),
                                  ),
                                  validator: (value) {
                                    final number = int.tryParse(value!);
                                    if (value.isEmpty) {return 'Please enter an username';}
                                      //return 'Please enter an username';
                                    //}
                                    if (number == null) {return 'Please enter a valid number';}
                                      //return 'Please enter a valid number';
                                    //}

                                    //}

                                    //}
                                    /*if (number<transferData?['min'] || number>transferData?['max']) {
                          return 'Number must be > ${transferData?['min']} and < ${transferData?['max']}';
                        }*/
                                    return null;
                                  },
                                  onSaved: (v) {
                                    transferData['username'] = _usernameController.text;
                                  },

                                  //},
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _amountController,
                                  decoration: InputDecoration(
                                    label: Text('Amount'),
                                  ),
                                  validator: (value) {
                                    final number = int.tryParse(value!);
                                    if (value.isEmpty) return 'Please enter transfer amount';
                                      //return 'Please enter transfer amount';
                                    if (number == null) return 'Please enter a valid number';
                                      //return 'Please enter a valid number';

                                    //}

                                    //}
                                    /*if (number<transferData?['min'] || number>transferData?['max']) {
                            return 'Number must be > ${transferData?['min']} and < ${transferData?['max']}';
                          }*/
                                    return null;
                                  },
                                  onSaved: (v) {
                                    transferData['amount'] = _amountController.text;
                                  },

                                  //},
                                ),
                                SizedBox(height: 20),
                                FilledButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      if (context.read<DepositProvider>().balance['balanceType']! < transferData['balanceType']) {
                                        Toast({'message': 'পর্যাপ্ত ব্যাল্যান্স নেই', 'success': false,});
                                        return;
                                      }
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return ChangeNotifierProvider.value(
                                            value: Provider.of<AuthProvider>(context,),
                                            child: PIN(/*proceed: nextStep,*/),
                                          );
                                        },
                                      );
                                      if (context.watch<AuthProvider>().matchedPIN) {
                                        /*if (res == null) {
                                          Toast({'message':'কিছু একটা সমস্যা হয়েছে', 'success': false,});
                                          return;
                                        }*/

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
                        ),
                        if(auth.matchedPIN)...[
                          Column(
                            children: [
                              //Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text(_selectedUserName),/*Text(_selectedType)*/]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:[
                                  Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text(_usernameController.text),Text(_typeController.text)]),
                                  /*Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text('পরিমাণ'), */Text('\u09F3 ${_amountController.text}')//])
                                ]
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:[Text('নতুন ব্যালেন্স / ব্যবহারযোগ্য ব্যালেন্স'),Text('${balance[_typeController.text]!-(int.parse(_amountController.text))} / ${balance[_typeController.text]}')]
                                  )
                                ]
                              ),SizedBox(height: 40,),
                              CircleFillWidget(doTask:transfer)
                            ],
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
