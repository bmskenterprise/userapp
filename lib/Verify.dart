import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Index.dart';
//import 'widgets//PIN.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});
  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerPIN =TextEditingController();
  /*@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
          context: context, 
          builder: (context){
            return ChangeNotifierProvider.value(
              value: Provider.of<AuthProvider>(context),
              child: PIN(/*proceed: nextStep,*/)
            );
          }
        );
    });
  }*/
  @override
  void dispose() {
    _controllerPIN.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if(auth.matchedPIN){print('object');
        Navigator.push(context, MaterialPageRoute(builder: (route) => const Index()));//});
    }
    return Scaffold(
      body: Expanded(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controllerPIN,
                  decoration: const InputDecoration(
                    //alignLabelWithHint: true,
                    labelText: 'Enter PIN',
                  ),
                  obscureText: true,
                  validator: (v){
                    if(v==null){return 'Enter PIN';}
                    if(!(RegExp(r'^\d{4,6}$').hasMatch(v))){return 'Invalid PIN';}
                    return null;
                  },
                ),
                SizedBox(height: 60,),
                ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      context.read<AuthProvider>().validatePIN(_controllerPIN.text);Navigator.push(context, MaterialPageRoute(builder: (context)=>Index()));
                    }
                    if(auth.matchedPIN) {print('index');Navigator.push(context, MaterialPageRoute(builder: (context)=>Index()));}
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('VERIFY'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}