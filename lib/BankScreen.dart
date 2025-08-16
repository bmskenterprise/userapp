import 'package:bmsk_userapp/CircleFill.dart';
import 'package:bmsk_userapp/FullScreenLoader.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/ApiProvider.dart';
import 'package:bmsk_userapp/providers/OperatorListProvider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


class BankScreen extends StatefulWidget {
  const BankScreen({super.key});
  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  late TextEditingController _acNumberController;late TextEditingController _acNameController;
  late TextEditingController _amountController;
  late String _selectedBankName;
  late List<String> bankNames;late Box hiveBox;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperatorListProvider>(context, listen: false).fetchBankNames();//deposits=context.watch<OperatorListProvider>().deposits;
      bankNames=context.watch<OperatorListProvider>().bankNames.cast<String>();_selectedBankName=bankNames[0];
      hiveBox = Hive.box('permission');
    });
  }
  
  void bankRequest()async{
    bool status=await context.read<ApiProvider>().postBank(_selectedBankName,_acNumberController.text,_acNameController.text,int.parse(_amountController.text));
    if(status) context.read<AuthProvider>().disablePINConnection();
  }
  
  @override
  Widget build(BuildContext context) {
    final bankBalance=context.watch<AuthProvider>().balance['bank'];
    final auth=context.watch<AuthProvider>();
    return  hiveBox.get('services').contains('deposit')?Center(child: Text('এই মুহূর্তে ব্যাংক লেনদেন করার অনুমতি নেই'),) : PopScope(
      canPop: !(auth.matchedPIN), // যদি next=false হয়, তাহলে back করা যাবে
      onPopInvokedWithResult: (bool didPop, Object? result){
        if(!didPop && auth.matchedPIN) context.read<AuthProvider>().disablePINConnection();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Pay Bill')),
        body: context.watch<OperatorListProvider>().loading?Center(child: CircularProgressIndicator(),) : Stack(
          children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                if(!auth.matchedPIN)...[Form(
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        value: _selectedBankName,
                        items: bankNames.map((option) => DropdownMenuItem(value: option,  child: Text(option),)).toList(),
                        onChanged: (String? v) {
                            setState(() {
                              _selectedBankName = v!;
                            });
                          }
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _acNumberController,
                        decoration: InputDecoration(
                          hintText: 'Accont Number',
                        ),
                        validator: (v) => (v==null || v.length>50)?'invalid':null,
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _amountController,
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
                        onPressed: (){},
                        child: Text('next')
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
                              Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text('ব্যাংক অ্যাকাউন্ট  নাম্বার'),Text(_acNumberController.text)]),
                              Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text('পরিমাণ'), Text('\u09F3 ${_amountController.text}')])
                            ]
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[Text('নতুন ব্যালেন্স / ব্যবহারযোগ্য ব্যালেন্স'),Text('${bankBalance!-(int.parse(_amountController.text))} / $bankBalance')]
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