import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/TelecomProvider.dart';
import 'widgets/CircleFill.dart';
import 'widgets/PIN.dart';
import 'widgets/Toast.dart';
import 'FullScreenLoader.dart';
//import 'services/AuthService.dart';
import 'providers/DepositProvider.dart';
//import 'services/PackService.dart';

class PackHit extends StatefulWidget {
  final Map pack;
  const PackHit({super.key, required this.pack});
  @override
  State<PackHit> createState() => _PackHitState();
}


class _PackHitState extends State<PackHit> {
  final TextEditingController _controllerRecipient = TextEditingController();
  //final balance = Provider.of<SignUpData>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  void topup()async {
    bool status=await context.read<TelecomProvider>().topup(widget.pack['operator'],_controllerRecipient.text,widget.pack['price']);
    if(status) context.read<AuthProvider>().disablePINConnection();
  }
  
  @override
  void dispose() {
    _controllerRecipient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final deposit = context.watch<DepositProvider>();// যদি next=false হয়, তাহলে back করা যাবে
    return PopScope(
      canPop: !(auth.matchedPIN),
      onPopInvokedWithResult: (bool didPop, Object? result){
        if(!didPop && auth.matchedPIN) context.read<AuthProvider>().disablePINConnection();
      },
    child: Scaffold(
      // appBar: ,
      body: Stack(
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:[
                  if(!context.watch<AuthProvider>().matchedPIN)...[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _controllerRecipient,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              hintText: 'Mobile Number  ',
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Please enter a number' : null,
                          ),SizedBox(height: 40,),
                          FilledButton(
                            onPressed: () {
                              //String pin=AuthService().getPin() as String;
                              if(widget.pack['price']>deposit.balance['topup']){Toast({'message':'','success':false});return;}
                              if(_formKey.currentState!.validate()){
                                _formKey.currentState!.save();showModalBottomSheet(
                                                context: context, 
                                                builder: (context){
                                                  return ChangeNotifierProvider.value(
                                                    value: Provider.of<AuthProvider>(context),
                                                    child: PIN(/*proceed: nextStep,*/)
                                                  );
                                                }
                                              );
                              }//  v
                              //}
                            },
                            child: Text('Next')
                          )
                        ],
                      ),
                    ),
                  ],
                  if(context.watch<AuthProvider>().matchedPIN)...[
                    Text(widget.pack['title']),
                    Row(
                      children: [
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[Text('কমিশন / প্রতি প্যাক'),Text('${widget.pack['deduct']} / ${widget.pack['price']}')]
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[Text('নতুন ব্যালেন্স / ব্যবহারযোগ্য ব্যালেন্স'),Text('${deposit.balance['topup']!-(int.parse(widget.pack['price']))} / ${deposit.balance['topup']}')]
                        )
                      ]
                    ),
                    CircleFillWidget(doTask: topup)
                  ]
            ]
          ),
        ),
        context.watch<TelecomProvider>().loading?FullScreenLoader():Container()]
      ),
    ),
  );
  }
}