//import 'package:bmsk_userapp/PIN.dart';
import 'package:bmsk_userapp/PackHit.dart';
import 'package:bmsk_userapp/Toast.dart';
//import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/TransferProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pack extends StatelessWidget {
  final Map pack, opt;
  const Pack({super.key, required this.pack,required this.opt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {if(pack['price']>context.read<TransferProvider>().balance){ Toast({'message':'পর্যাপ্ত ব্যাল্যান্স নেই','success':false});}else{Navigator.push(context, MaterialPageRoute(builder: (context) => PackHit(pack: pack,)),);}
        /*showModalBottomSheet(
              context: context,
              builder: (BuildContext context){
                return ChangeNotifierProvider.value(
                  value: Provider.of<AuthProvider>(context),
                  child: PIN()
                );*/
                            /*Column(
                  children: [
                    Text('PIN'),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter PIN',
                      ),onChanged: (v){if(v==pin){
                        final res= PackService().packHit(widget.pack.packId, _consumerController.text);
                        if(res.status=='success'){
                          Toast({'message': 'Pack Hit Successfully', 'success': true});
                          Navigator.pop(context);
                        }
                        if(res.status=='failed'){
                          Toast({'message':'Pack Hit failed',  'success':false });
                          Navigator.pop(context);
                        }
                      }},
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a PIN' : null,
                    ),

                  ],
                );*/
              /*}
            );
        if(context.watch<AuthProvider>().matchedPIN){}*/
      },
      child: Container(
        height: 140,
        margin: EdgeInsets.only(bottom:30),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF141218),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2.0,
              offset: Offset(-1,-1),
              color: Color(0xFF000000)
            ),
            BoxShadow(
              blurRadius: 2.0,
              offset: Offset(1,1),
              color: Color(0xFF000000)
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right:20 ),
              child: Image.asset(opt['logo'], width:20,)
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start, 
                children: [
                  Text(pack['name'], style:TextStyle(color:opt['color'], fontSize:12, fontWeight:FontWeight.bold  ),),
                  SizedBox(height: 25),
                  Text(pack['name']),
                ],
              )
            )
            ]
        ),
      ),
    );
  }
}