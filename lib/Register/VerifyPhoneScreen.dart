import 'package:bmsk_userapp/providers/SignUpDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyUserScreen extends StatefulWidget {
  final Function nextHandler;
  const VerifyUserScreen({super.key,required this.nextHandler});
  @override
  State<VerifyUserScreen> createState() => VerifyUserScreenState();
}


class VerifyUserScreenState extends State<VerifyUserScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final validPin = args['pin'];
    return  SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              Text('Validate',style: TextStyle(fontSize: 30),),
              Row(children:[Text('Enter the code sent to the number'), Text(Provider.of<SignUpData>(context, listen: false).username,style: TextStyle(),)])
            ]

          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                Pinput(
                  validator: (value) {
                    return value==validPin? null : 'Invalid Pin';
                  },
                  onCompleted: (v){
                    Navigator.pushNamed(context, '/index');
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
                  onPressed: (){
                    formKey.currentState!.validate();
                  },
                  child:const Text('Validate')
                )
                  // child:const Text('Validate')
                //)
              ],
            ),
          )
        ],
        ),
    );
  }
                  // },
  @override
  void dispose() {
    _controller.dispose(); // Always dispose controllers to avoid memory leaks
    super.dispose();
  }
}