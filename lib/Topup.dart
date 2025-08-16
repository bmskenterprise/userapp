import 'package:bmsk_userapp/CircleFill.dart';
import 'package:bmsk_userapp/FullScreenLoader.dart';
import 'package:bmsk_userapp/PIN.dart';
import 'package:bmsk_userapp/providers/OperatorListProvider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/TopupProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});
  @override
  State<TopupScreen> createState() => _TopupState();
}


class _TopupState extends State<TopupScreen> {
  int _activeIndex = -0;
  // bool _matchedPIN = false;
  final _formKey = GlobalKey<FormState>();
 String _selectedOperator = 'Airtel';
  Map data = {};
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {context.read<OperatorListProvider>().getTopupTelecoms();});
}
  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

/*void topupRequest(){
  bool status=context.read<TopupProvider>().topup(_recipientController.text,_selectedOperator,_amountController.text);
  if(status)context.read<AuthProvider>().disablePINConnection();
}*/
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final _telecoms = context.watch<OperatorListProvider>().operators;
    return PopScope(
      canPop: !(auth.matchedPIN), // যদি next=false হয়, তাহলে back করা যাবে
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop && auth.matchedPIN) {
          // যদি pop না হয় এবং next=true থাকে, তাহলে next=false করে দাও
          /*setState(() {
            _next = false;
          });*/context.read<AuthProvider>().disablePINConnection();
        }
      },
      child: Scaffold(
      appBar: AppBar(title: const Text("Topup")),
      body: auth.loading?FullScreenLoader():Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!(auth.matchedPIN)) ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_telecoms.length, (index) {
                        bool isActive = _activeIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeIndex = index;
                              _selectedOperator = _telecoms[index]['value'];
                            });
                            //print("Selected Value: $selectedValue");
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive ? Colors.blue : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Image.network(
                              _telecoms[index]['icon']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      })
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        SizedBox(width:200,child:TextFormField(
                          controller: _recipientController,
                          keyboardType: TextInputType.numberWithOptions(decimal: false,),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text('Mobile Number',style:TextStyle(fontSize:12)),
                            icon: Icon(Icons.phone),
                          ),
                          validator: (value) {
                            // final number = int.tryParse(value!);
                            if (value == null || value.isEmpty) {
                              return 'Please enter a mobile number';
                            }
                            if (!RegExp(
                              r'^(?:\+88|88)?01[3-9]\d{8}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (v) {
                          data['mobile'] = _mobileController.text;
                        },
                        )),
                        SizedBox(
                          width: 80,
                          child: DropdownButtonFormField(
                            value: _selectedOperator,
                            items: context.read().operators.map<DropdownMenuItem<String>>((op) => DropdownMenuItem<String>(
                                        value: op.name,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [Image.network(op.icon),
                                          Text(op.name),],
                                        ),
                                      ),
                            ).toList(),
                            onChanged: (String? v) {
                              setState(() {
                                _selectedOperator = v!;
                              });
                            },
                          ),
                        )
                    ]),*/
        
      if(_activeIndex>=0)...[SizedBox(width:200,child:TextFormField(
                          controller: _recipientController,
                          keyboardType: TextInputType.numberWithOptions(decimal: false,),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text('Mobile Number',style:TextStyle(fontSize:12)),
                            icon: Icon(Icons.phone),
                          ),
                          validator: (value) {
                            // final number = int.tryParse(value!);
                            if (value == null || value.isEmpty) {
                              return 'Please enter a mobile number';
                            }
                            if (!RegExp(
                              r'^(?:\+88|88)?01[3-9]\d{8}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (v) {
                          data['mobile'] = _recipientController.text;
                        },
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('পরিমাণ',style:TextStyle(fontSize:12)),
                        icon: Text('\u09F3',style: TextStyle(fontSize: 25)),
                      ),
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final number = int.tryParse(value!);
                        if (value == null || value.isEmpty) {
                          return 'Please enter some amount';
                        }
                        if (number == null) {
                          return 'Please enter a valid number';
                        }
                        if (number < 20 || number > 2000) {
                          return 'Number must be > 20 and < 2000';
                        }
                        return null;
                      },
                      onSaved: (v) {
                        data['amount'] = _amountController.text;
                      },
                    )],
                    SizedBox(height: 80),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          showModalBottomSheet(
                            context:context, 
                            builder: (context){
                              return ChangeNotifierProvider.value(
                                value: Provider.of<AuthProvider>(context),
                                child: PIN()
                              );
                            }
                          );
                        }
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
            if (auth.matchedPIN) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width*0.6,
                        height:80,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(data['ব্যবহারযোগ্য ব্যাল্যান্স']), Text('\u09F3${data['']}', style: TextStyle(fontSize: 18),)],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(data['নতুন ব্যাল্যান্স']), Text('\u09F3${data['']}', style: TextStyle(fontSize: 18),)],
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(''),Text('\u09F3${data}')],
                      )
                    ],
                  ),SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [Image.asset(data['operator']['icon']),Text(data['mobile'])],),
                      Column(
                        children: [Text('রিচার্জ পরিমাণ'), Text('\u09F3${data['amount']}', style: TextStyle(color: Colors.green, fontSize: 20),),],
                      ),
                    ],
                  ),SizedBox(height: 80),
                  CircleFillWidget(doTask:(){
  bool status=context.read<TopupProvider>().topup(_recipientController.text,_selectedOperator,int.parse(_amountController.text));
  if(status)context.read<AuthProvider>().disablePINConnection();
}/*topupRequest*/)
                ],
              ),
            ],
          ],
        ),
      ),
    ));
  }
}
