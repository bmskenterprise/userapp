import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AppProvider.dart';
import 'providers/AuthProvider.dart';
import 'providers/ApiProvider.dart';
import 'providers/DepositProvider.dart';
import 'FullScreenLoader.dart';
import 'widgets/Offline.dart';
import 'widgets/CircleFill.dart';
import 'widgets/PIN.dart';
import 'widgets/Toast.dart';

                  
class PayBill extends StatefulWidget {
  const PayBill({super.key});
  @override
  State<PayBill> createState() => _PayBillState();
}


class _PayBillState extends State<PayBill> {
  //late Box box;
  Map<String, List<String>> categories={
    'Electricity':['Palli Bidyut (Prepaid)','Palli Bidyut (Postpaid)','DESCO (Prepaid)','DESCO (Postpaid)','NESCO (Prepaid)','NESCO (Postpaid)'],
    'Internet':['Amber IT','Carnival','Circle Network','DOT Internet','KS Network LTD','Link3','BDCOM Online Ltd','Mazeda Network Limited','Millenium Computers & Networking','Sam Online','Triangle'],
    'Gas':['Titas Gas Postpaid (Non-metered)','Titas Gas Postpaid (Metered)','Karnaphuli Gas','Jalalabad Gas'],
    'Water':['Dhaka WASA','Chattogram WASA','Rajshahi WASA','Khulna WASA'],
    'Cable TV':['Akash DTH','Bengal Digital','BumbellBee','Nation Electronics & Cable Network']
  };
  late List<String> billTypes;
  late List<String> subTypes;late String _selectedType;late String _selectedSubType;
  late TextEditingController _controllerAmount;
  late TextEditingController _controllerAC;
  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerACName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    billTypes=categories.keys.toList();
    _selectedType=billTypes.first;
    subTypes=categories[_selectedType]!;_selectedSubType=subTypes.first;
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperatorListProvider>(context, listen: false).fetchBillTypes();//deposits=context.watch<OperatorListProvider>().deposits;
      box = Hive.box('permission');
    });*/
  }
  @override
  void dispose() {
    _controllerAmount.dispose();
    _controllerAC.dispose();
    _controllerACName.dispose();
    _controllerDate.dispose();
    super.dispose();
  }
  void billRequest()async{
    bool status=await context.read<ApiProvider>().postBill(_selectedType,_controllerAC.text,int.parse(_controllerAmount.text),_controllerDate.text,_controllerACName.text);
    if(status) context.read<AuthProvider>().disablePINConnection();
  }
  
  @override
  Widget build(BuildContext context) {
    final auth=context.watch<AuthProvider>();
    final isInternetConnected=context.watch<AppProvider>().isInternetConnected;
    final bankBalance=context.watch<DepositProvider>().balance['bank'];
    return !(auth.authPrefs['accesses']??[]).contains('bill')?Center(child: Text('এই মুহূর্তে পে বিল করার অনুমতি নেই'),) : !isInternetConnected?Offline():PopScope(
      canPop: !(auth.matchedPIN), // যদি next=false হয়, তাহলে back করা যাবে
      onPopInvokedWithResult: (bool didPop, Object? result){
        if(!didPop && auth.matchedPIN) context.read<AuthProvider>().disablePINConnection();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Pay Bill')),
        body: /*context.watch<Provider>().loading?Center(child: CircularProgressIndicator(),) :*/ Stack(
          children: [Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                if(!auth.matchedPIN)...[Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: billTypes.map((option) => DropdownMenuItem(value: option,
                                    child: Text(option),)).toList(),
                        onChanged: (String? v) {
                            setState(() {
                              _selectedType = v!;subTypes=categories[_selectedType]!;_selectedSubType=subTypes.first;
                            });
                          }
                      ),SizedBox(height: 40,),
                    DropdownButtonFormField<String>(
                      value:_selectedSubType,
                      items:subTypes.map<DropdownMenuItem<String>>((String i)=>DropdownMenuItem<String>(value:i,child:Text(i))).toList(),
                      onChanged:(String? v){
                        setState((){
                            _selectedSubType=v!;
                          
                        });
                      }
                    ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _controllerAC,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Biil Account Number',
                        ),
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _controllerAmount,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Bill Amount',
                        ),
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Bill Month',
                        ),
                      ),
                      TextFormField(
                        controller: _controllerDate,
                        decoration: InputDecoration(
                          hintText: 'Last Pay Date',
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      TextFormField(
                        controller: _controllerACName,
                        decoration: InputDecoration(hintText: 'ac name'),
                      ),SizedBox(height: 60,),
                      FilledButton(
                        onPressed: ()async{
                          if(double.parse(_controllerAmount.text) > bankBalance!){ Toast({'message':'পর্যাপ্ত ব্যাল্যান্স নেই', 'success':false});}
                          else{
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
                              /*if(context.watch<AuthProvider>().matchedPIN){
                                final res=await context.read<PaymentProvider>().setPaymentInit(paymentData['balanceType'],paymentData['amount']);
                                if (res==null) {
                                  Toast({'message':'কিছু একটা সমস্যা হয়েছে','success':false});return;
                                }
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebView(url: res)));
                              }*/
                            }
                          }
                        },
                        child: Text('next')
                      )
                    ],
                  )
                )],
                if(auth.matchedPIN)...[
                  Column(
                    children: [
                      Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text(_selectedSubType),Text(_selectedType)]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Column(crossAxisAlignment:CrossAxisAlignment.center, children:[Text('বিল অ্যাকাউন্ট  নাম্বার'),Text(_controllerAC.text)]),
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
                      CircleFillWidget(doTask:billRequest)
                    ],
                  )
                ]
              ],
            ),
          ),
          context.watch<ApiProvider>().loading?FullScreenLoader():SizedBox()],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null){
      setState(() {
        _controllerDate.text = picked.toString().split(' ')[0];
      });
    }
  }
}