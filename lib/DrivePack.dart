import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/TelecomProvider.dart';
import 'providers/DepositProvider.dart';
import 'DriveHit.dart';
import 'widgets/Toast.dart';

class DrivePack extends StatelessWidget {
  final Map pack;
  //final Map<String,String> opt;
  const DrivePack({super.key, required this.pack/*,required this.opt*/});

  @override
  Widget build(BuildContext context) {
    final telecom=context.read<TelecomProvider>();
    return GestureDetector(
      onTap: () {if(pack['price']>context.read<DepositProvider>().balance){ Toast({'message':'পর্যাপ্ত ব্যাল্যান্স নেই','success':false});}else{Navigator.push(context, MaterialPageRoute(builder: (context) => PackHit(pack: pack,)),);}
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
              child: Image.asset(telecom.currentDriveOpt['icon']!, width:20,)
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start, 
                children: [
                  Text(pack['title'], style:TextStyle(color:telecom.currentDriveOpt['color'], fontSize:12, fontWeight:FontWeight.bold  ),),
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