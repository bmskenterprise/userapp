import 'package:bmsk_userapp/FullScreenLoader.dart';
import 'package:bmsk_userapp/History/FilterUI.dart';
import 'package:bmsk_userapp/models/History/DepositHistory.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/HistoryProvider.dart';
import 'package:bmsk_userapp/providers/NotificationProvider.dart';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepositHistoryScreen extends StatefulWidget {
  const DepositHistoryScreen({super.key});
  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreen();
}


class _DepositHistoryScreen extends State<DepositHistoryScreen> {
  late List<DepositHistory> _deposits;//late Map _histories;
  String searchQuery='';late List deposits;
  bool searchInit=false;
  String selected='failed';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      String status=context.read<NotificationProvider>().failedDepositCount>0?'failed':'success';
      /*_histories[status]=await */context.read<HistoryProvider>().fetchDepositHistory(status);selected=status;
      //_deposits=_histories[status];
      context.read<SocketProvider>().socket.emit('seen-failed-deposit',  context.read<AuthProvider>().username);
    });
  }

  void handleFilter (String v) {context.read<HistoryProvider>().filterDepositHistory(v);}
  void handleStatus(String v){
    /*setState(() {
      selected=v;
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v);_deposits=_histories[v];
      }*/
    context.read<HistoryProvider>().fetchDepositHistory(v);
    //});
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Deposit History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: (){
              context.read<HistoryProvider>().setFilterInit();
            },
          )
        ],
      ),
      body: Stack(
      children:[Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            if(context.read<HistoryProvider>().filterInit) FilterUI(['failed','success'],selected,handleStatus,handleFilter)/*TextField(
              decoration: InputDecoration(
                hintText: 'Search',
              ),
              onChanged: (String v){
                setState((){
                  searchQuery = v.toString();
                });
              },
            )*/,
            Expanded(
              child: ListView.builder(
                itemCount: _deposits.length,
                itemBuilder: (BuildContext context, int index) {
                  final deposit= _deposits[index];
                  if (searchQuery.isEmpty) {
                    return DepositTile(deposit);
                  }
                  else if([deposit.amount,deposit.balanceType,deposit.trxID,deposit.paymentMethod,deposit.date].any((value) => value.toLowerCase().contains(searchQuery.toLowerCase()))){
                    return DepositTile(deposit);
                  }else{
                    return Text('পাওয়া যায়নি');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      context.watch<HistoryProvider>().loading? FullScreenLoader():Container() ]),
    );
    //);
  }

  Widget DepositTile(deposit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[Row(children:[Text('\u09F3${deposit.amount}', style:TextStyle(fontSize: 20)), Text(deposit.type, style:TextStyle(fontSize: 16),)]),Text(' ${deposit.trxID}')]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('${deposit.date} ${deposit.method}'), Icon(Icons.close)/**/]
          ),
        ]
      )
    );
  }
}