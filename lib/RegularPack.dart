import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/DepositProvider.dart';
import 'providers/TelecomProvider.dart';
import 'DriveHit.dart';
import 'widgets/Toast.dart';
//import '/PIN.dart';

class RegularPack extends StatelessWidget {
  final Map pack;
  //final Map<String,String> opt;
  const RegularPack({super.key, required this.pack/*,required this.opt*/});

  @override
  Widget build(BuildContext context) {
    final telecom=context.read<TelecomProvider>();
    return GestureDetector(
      onTap: () {if(pack['price']>context.read<DepositProvider>().balance){ Toast({'message':'পর্যাপ্ত ব্যাল্যান্স নেই','success':false});}else{Navigator.push(context, MaterialPageRoute(builder: (context) => PackHit(pack: pack,)),);}
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
              child: Image.asset(telecom.currentRegularOpt['icon']!, width:20,)
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start, 
                children: [
                  Text(pack['title'], style:TextStyle(color:telecom.currentRegularOpt['color'], fontSize:12, fontWeight:FontWeight.bold  ),),
                  SizedBox(height: 25),
                  Text(pack['price']),
                ],
              )
            )
            ]
        ),
      ),
    );
  }
}