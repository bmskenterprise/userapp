import 'dart:convert';
import 'package:bmsk_userapp/Deposit/Payment.dart';
import 'package:bmsk_userapp/Deposit/Manual.dart';
import 'package:flutter/material.dart';


class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});
  @override
  State<AddBalanceScreen> createState() => _AddBalanceState();
}


class _AddBalanceState extends State<AddBalanceScreen> {
  Future depositInfo()async{
    try{
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/v1/deposit'));
      setState(() {
        loading=false;
      });
      if (response.statusCode == 200){
        /*Map*/ depositData= jsonDecode(response.body);
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Balance!"),
            content: Column(
              children:[Text("minimum \u09F3${depositData?['min']} "), Text("maximum \u09F3${depositData?['max']} .")]
            ),
            actions: [
              TextButton(
                child: Text("ok"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      }
     }catch(e) {
          print(e);
          }
  }

  @override
  void initState() {
    super.initState();depositInfo();
    box = Hive.box('permission');/*WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Welcome!"),
            content: Text("You navigated to the second screen."),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });*/
  }
  @override
  Widget build(BuildContext context) {
    return box.get('services').contains('deposit')?Center(child: Text('এই মুহূর্তে ডিপজিট করার অনুমতি নেই'),): Scaffold(
      appBar: AppBar(
        title: Text('Add Balance'),
        bottom: TabBar(tabs: [Text('Manual'),Text('Payment')]),
      ),
      body: TabBarView(children: [Manual(),Payment()])
  }
}
