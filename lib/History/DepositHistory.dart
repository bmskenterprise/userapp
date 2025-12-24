import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/HistoryProvider.dart';
import '../providers/NotificationProvider.dart';
import '../providers/AppProvider.dart';
import '/FullScreenLoader.dart';
import 'FilterUI.dart';
import '../widgets/Pages.dart';
//import 'package:bmsk_userapp/models/History/DepositHistory.dart';

class DepositHistory extends StatefulWidget {
  const DepositHistory({super.key});
  @override
  State<DepositHistory> createState() => _DepositHistory();
}


class _DepositHistory extends State<DepositHistory> {
  //late List<DepositHistory> _deposits;//late Map _histories;
  String searchQuery='';late List deposits;
  bool searchInit=false;
  String selected='failed';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String status=context.read<NotificationProvider>().failedDepositCount>0?'FAILED':'SUCCESS';
      /*_histories[status]=await */context.read<HistoryProvider>().changeStatus(status);context.read<HistoryProvider>().getDepositHistory();selected=status;
      //_deposits=_histories[status];
      context.read<AppProvider>().socket.emit('seen-failed-deposit',  context.read<AuthProvider>().username);
    });
  }

  void filter (context,String v) {context.read<HistoryProvider>().filterDepositHistory(v);}
  void handleStatus(context,String v){
    /*setState(() {
      selected=v;
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v);_deposits=_histories[v];
      }*/
    context.read<HistoryProvider>().getDepositHistory();
    //});
  }

  @override
  Widget build(BuildContext context) {
    final history=context.watch<HistoryProvider>().history;
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
            if(context.read<HistoryProvider>().filterInit) SizedBox(height:60,child:FilterUI(states:['failed','success'],selected:selected,statusHandler:handleStatus,filterHandler:filter)/*TextField(
              decoration: InputDecoration(
                hintText: 'Search',
              ),
              onChanged: (String v){
                setState((){
                  searchQuery = v.toString();
                });
              },
            )*/),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Expanded(
                child: ListView.builder(
                  itemCount: history['deposits']?.length ??0,
                  itemBuilder: (BuildContext context, int index) {
                    final deposits = history['deposits'];
                    if(deposits==null|| deposits.isEmpty) {return Center(child:Text('পাওয়া যায়নি'));}
                    final deposit= deposits[index];
                    if (searchQuery.isEmpty) {return DepositTile(deposit);}
                    
                    else if([deposit['amount'],deposit['balanceType'],deposit['txn'],deposit['gateway'],deposit['updatedAt']].any((value) => value.toLowerCase().contains(searchQuery.toLowerCase()))){
                      return DepositTile(deposit);
                    }else {return Text('পাওয়া যায়নি');}
                    
                  },
                ),
              ),
            ),
            if(history['pagination']['totalPage']>1) Pages(totalPage:history['pagination']['totalPage'],currentPage:history['pagination']['currentPage'],onPageChange:(int p){context.read<HistoryProvider>().getDepositHistory(p);})
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
            children:[Row(children:[Text('\u09F3${deposit['amount']}', style:TextStyle(fontSize: 20)), Text(deposit['balanceType'], style:TextStyle(fontSize: 16),)]),Text(' ${deposit['txn']}')]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('${deposit['updatedAt']} ${deposit['gateway']}'), Icon(Icons.close)]
          ),
        ]
      )
    );
  }
}