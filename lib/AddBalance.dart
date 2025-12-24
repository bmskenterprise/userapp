//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/DepositProvider.dart';
import 'PaymentGatewayFragment.dart';
import 'PaymentManualFragment.dart';


class AddBalance extends StatefulWidget {
  const AddBalance({super.key});
  @override
  State<AddBalance> createState() => _AddBalanceState();
}


class _AddBalanceState extends State<AddBalance> {
//late Box box;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepositProvider>().getDepositRangeInfo();
      Map<String,Map<String,int>> deposit=context.watch<DepositProvider>().depositRange;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Deposit"),
            content: Column(children:[Text('Topup'),Text("Minimum ${deposit['topupDeposit']!['min']} to the Maximum ${deposit['topupDeposit']!['max']}"),Text('Bank'),Text("Minimum ${deposit['bankDeposit']!['min']} to the Maximum ${deposit['bankDeposit']!['max']}")]),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return /*!(auth.authPrefs['accesses']??[]).contains('deposit')?Center(child: Text('এই মুহূর্তে ডিপজিট করার অনুমতি নেই'),):*/ DefaultTabController(
      length:2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Balance'),
          bottom: TabBar(tabs: [Text('Manual'),Text('Payment')]),
        ),
        body: TabBarView(children: [PaymentManualFragment(),PaymentGatewayFragment()])
      ),
    );
  }
}
