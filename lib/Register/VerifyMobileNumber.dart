import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/RegisterProvider.dart';
import '../Index.dart';

class VerifyMobileNumber extends StatefulWidget {
  //final Function nextHandler;
  const VerifyMobileNumber({super.key/*,required this.nextHandler*/});
  @override
  State<VerifyMobileNumber> createState() => _VerifyMobileNumberState();
}


class _VerifyMobileNumberState extends State<VerifyMobileNumber> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){context.read<RegisterProvider>().getOTP();});
  }

                    
                  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final validPin = args['pin'];
    final reg = context.watch<RegisterProvider>(); //controllers to avoid memory leaks
    return  SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              Text('Validate',style: TextStyle(fontSize: 30),),
              Row(children:[Text('Enter the code sent to the number'), Text(reg.regData['username'] /*Provider.of<RegisterProvider>(context,listen: false).username,style: TextStyle(),*/)])
            ]
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                Pinput(
                  validator: (value) {return value==reg.otp? null : 'Invalid Pin';},
                  onCompleted: (v){
                    context.read<AuthProvider>().register(reg.regData);
                    if(context.watch<AuthProvider>().loggedIn){Navigator.push(context, MaterialPageRoute(builder: (context)=>Index()));}
                  },
                  errorBuilder: (errorText, pin){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0),
                      child: Center(
                        child: Text(errorText??'',style:const TextStyle(color: Colors.red),),
                      ),
                    );
                  }
                ),
                FilledButton(
                  onPressed: (){formKey.currentState!.validate();},
                  child:const Text('Validate and Register')
                ),
                TextButton(
                  style: TextButton.styleFrom(textStyle:const TextStyle(color:Colors.blue)),
                  onPressed: () {context.read<RegisterProvider>().getOTP();},
                  child:const Text('Don\'t get the otp? Resend Code'),
                )  
                  
              ],
            ),
          )
        ],
        ),
    );
  }
                  // },
}