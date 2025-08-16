import 'package:bmsk_userapp/Circlefill.dart';
import 'package:bmsk_userapp/FullScreenLoader.dart';
import 'package:bmsk_userapp/PIN.dart';
import 'package:bmsk_userapp/providers/ApiProvider.dart';
//import 'package:bmsk_userapp/services/AuthService.dart';
import 'package:bmsk_userapp/Toast.dart';
//import 'package:bmsk_userapp/providers/SignUpData.dart';
//import 'package:bmsk_userapp/services/PackService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';

class PackHit extends StatefulWidget {
  final dynamic pack;
  const PackHit({super.key, required this.pack});
  @override
  State<PackHit> createState() => _PackHitState();
}


class _PackHitState extends State<PackHit> {
  final TextEditingController _recipientController = TextEditingController();
  //final balance = Provider.of<SignUpData>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  void driveHit()async {
    bool status=await context.read<ApiProvider>().postDrive(_recipientController.text,widget.pack.opt);if(status) context.read<AuthProvider>().disablePINConnection();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return PopScope(
      canPop: !(auth.matchedPIN), // যদি next=false হয়, তাহলে back করা যাবে
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
                            controller: _recipientController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              hintText: 'Enter number of hits',
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Please enter a number' : null,
                          ),SizedBox(height: 40,),
                          FilledButton(
                            onPressed: () {
                              //String pin=AuthService().getPin() as String;
                              if(widget.pack.price>context.read<AuthProvider>().balance['topup']){Toast({'message':'','success':false});return;}
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
                    Text(widget.pack.packTitle),
                    Row(
                      children: [
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[Text('কমিশন / প্রতি প্যাক'),Text('${widget.pack.deduct} / ${widget.pack.price}')]
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[Text('নতুন ব্যালেন্স / ব্যবহারযোগ্য ব্যালেন্স'),Text('${context.read<AuthProvider>().balance['topup']!-(int.parse(widget.pack.price))} / ${context.read<AuthProvider>().balance['topup']}')]
                        )
                      ]
                    ),
                    CircleFillWidget(doTask: driveHit)
                  ]
            ]
          ),
        ),
        context.watch<ApiProvider>().loading?FullScreenLoader():Container()]
      ),
    ),
  );
  }
}