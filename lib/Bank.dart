import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/ApiProvider.dart';
import 'providers/AppProvider.dart';
import 'providers/DepositProvider.dart';
import 'FullScreenLoader.dart';
import 'widgets/CircleFill.dart';
import 'widgets/PIN.dart';
import 'widgets/Offline.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});
  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  final _formKey = GlobalKey<FormState>();  // যদি next=false হয়, তাহলে back করা যাবে
  late TextEditingController _controllerACNumber;
  late TextEditingController _controllerACName;
  late TextEditingController _controllerAmount;
  late String _selectedBankName;
  late List<String> bankNames;late Map authPrefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(context, listen: false).getBankNames();//deposits=context.watch<OperatorListProvider>().deposits;
      //bankNames=context.watch<OperatorListProvider>().bankNames.cast<String>();
      _selectedBankName=bankNames[0];
      //authPrefs = context.read<AuthProvider>().getAuth();
    });
  }
  @override
  void dispose() {
    _controllerACNumber.dispose();
    _controllerACName.dispose();
    _controllerAmount.dispose();
    super.dispose();
  }
  void bankRequest(BuildContext context)async{
    bool status=await context.read<ApiProvider>().postBank(_selectedBankName,_controllerACNumber.text,_controllerACName.text,int.parse(_controllerAmount.text));
    if(status) context.read<AuthProvider>().disablePINConnection();
  }
  
  @override
  Widget build(BuildContext context) {
    final bankBalance=context.watch<DepositProvider>().balance['bank'];
    final auth=context.watch<AuthProvider>();
    final api=context.watch<ApiProvider>();
    final isInternetConnected=context.watch<AppProvider>().isInternetConnected;
    return  !(auth.authPrefs['accesses']??[]).contains('bank')?Center(child: Text('এই মুহূর্তে ব্যাংক লেনদেন করার অনুমতি নেই'),) : isInternetConnected?Offline():PopScope(
      canPop: !(auth.matchedPIN),
      onPopInvokedWithResult: (bool didPop, Object? result){
        if(!didPop && auth.matchedPIN) context.read<AuthProvider>().disablePINConnection();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Pay Bill')),
        body: api.loading?Center(child: CircularProgressIndicator(),) : Stack(
          children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                if(!auth.matchedPIN)...[Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        value: _selectedBankName,
                        items: api.bankNames.map((option) => DropdownMenuItem(value: option,  child: Text(option),)).toList(),
                        onChanged: (String? v) {
                            setState(() {
                              _selectedBankName = v!;
                            });
                          }
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _controllerACNumber,
                        decoration: InputDecoration(
                          hintText: 'Accont Number',
                        ),
                        validator: (v) => (v==null || v.length>50)?'invalid':null,
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _controllerAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                        ),
                        validator: (v) => (v==null || v.length>50)?'invalid':null,
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Account Name',
                        ),
                        validator: (v) => (v==null || v.length>50)?'invalid':null,
                      ),
                      TextFormField(
                        //controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'Bank Branch Info',
                        ),
                        //readOnly: true,
                        //onTap: () => _selectDate(context),
                      ),
                      FilledButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            showModalBottomSheet(
                              context: context, 
                              builder: (context){
                                return ChangeNotifierProvider.value(
                                  value: Provider.of<AuthProvider>(context),
                                  child: PIN(/*proceed: nextStep,*/)
                                );
                              }
                            );
                          }
                        },
                        child: Text('Next')
                      )
                    ],
                  )
                )],
                if(auth.matchedPIN)...[
                  Column(
                    children: [
                      Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text(_selectedBankName),/*Text(_selectedType)*/]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text('ব্যাংক অ্যাকাউন্ট  নাম্বার'),Text(_controllerACNumber.text)]),
                              Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text('পরিমাণ'), Text('\u09F3 ${_controllerAmount.text}')])
                            ]
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[Text('নতুন ব্যালেন্স / ব্যবহারযোগ্য ব্যালেন্স'),Text('${bankBalance!-(int.parse(_controllerAmount.text))} / $bankBalance')]
                          )
                        ]
                      ),SizedBox(height: 40,),
                      CircleFillWidget(doTask:bankRequest)
                    ],
                  )
                ]
              ],
            ),
          ),
          context.watch<ApiProvider>().loading?FullScreenLoader():Container()
          ],
        ),
      ),
    );
  }
}