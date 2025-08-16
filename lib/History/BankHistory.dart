import 'package:bmsk_userapp/History/FilterUI.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:bmsk_userapp/providers/HistoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:bmsk_userapp/providers/NotificationProvider.dart';
//import 'package:bmsk_userapp/models/History/BankHistory.dart';

class BankHistoryScreen extends StatefulWidget {
  const BankHistoryScreen({super.key});
  @override
  State<BankHistoryScreen> createState() => _BankHistoryState();
}


class _BankHistoryState extends State<BankHistoryScreen> {
bool filterInit=false;
dynamic getStatus(status,feedback) {
    dynamic state;
    switch(status) {
      case 'pending':
        state= Icon(Icons.pending,color:Colors.cyan);break;
      case 'completed':
        state= Icon(Icons.check_circle,color:Colors.green);break;
      case 'failed':
        state= Text(feedback, style:TextStyle(color:Colors.red));break;
    }
    return state;
  }
  //List<BankHistory> _history = [];
  //Map<String, List<BankHistory>> _histories = {};
  String selected = 'pending';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      String status = context.read<NotificationProvider>().failedBankCount>0?'failed':'pending';selected=status;
      /*_histories[status] =await */context.read<HistoryProvider>().fetchBankHistory(status);
      //_history=_histories[status]!;
      context.read<SocketProvider>().socket.emit('seen-bank-failed',  context.read<AuthProvider>().username);//implement initState
    });
  }
  void handleFilter(String query){context.read<HistoryProvider>().filterBankHistory(query);}
void handleStatus(String v)  {
    /*selected=v;
      if(_histories.containsKey(v)){_history=_histories[v]!;}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v) as List<BankHistory>;
        _history=_histories[v]!;
      }*/
    context.read<HistoryProvider>().fetchBankHistory(v);
  //});
}
  @override
  Widget build(BuildContext context) {
    final List<dynamic> history = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank History'),
        actions: [IconButton(onPressed: (){context.read<HistoryProvider>().setFilterInit();}, icon: Icon(Icons.filter_list))],
      ),
      body: Stack(
        children:[
         Column(
          children: [
            if(context.watch<HistoryProvider>().filterInit) FilterUI(['pending','failed','success'],selected,handleStatus,handleFilter),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final h= history[index];
                  return Container(
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children:[Row(children:[Text(h.ac),Text(h.recipient, style:TextStyle(fontSize:12))]),Text('\u09F3${h.amount}')],
                        ),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [Text(h.date),Text('${h.status}')], 
                        )
                    /*:*/ ]
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        context.read<HistoryProvider>().loading ? Center(child: CircularProgressIndicator()): SizedBox.shrink(),
        ])
    );
  }
}

