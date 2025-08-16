//import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PIN extends StatefulWidget {
  const PIN({super.key});
  @override
  State<PIN> createState() => _PINState();
}


class _PINState extends State<PIN> {
  final _pinKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context,authProvider,child) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key:_pinKey,
            child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      SizedBox(width:MediaQuery.of(context).size.width*0.6,child:TextFormField(
                        controller: _pinController,
                          keyboardType: TextInputType.numberWithOptions(decimal: false,),
                          // textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text('Your PIN'),
                      errorText: authProvider.asyncError,
                          ),
                          validator: (value) => (value==null || value.isEmpty||  (!RegExp(r'^\d{4,6}$',).hasMatch(value))) ? 'Enter a valid PIN': null
                          //}
                      )),
                      authProvider.loading?SizedBox(width:20,height:20,child:CircularProgressIndicator()):SizedBox(
                        width: MediaQuery.of(context).size.width*0.2,
                        child:Center(
                        child: IconButton(
                        onPressed: ()async{
                          if(_pinKey.currentState!.validate()){
                            final matched/*res*/=await authProvider.validatePIN(_pinController.text);
                            if(matched/*authProvider.matchedPIN*/){
                              /*setState(() {
                                _next=true;
                              });*/Navigator.pop(context);
                            }/*else{
                              Toast(res);
                            }*/
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios)
                      ),))
                    ]
                  )));});
  }
}