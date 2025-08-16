import 'package:bmsk_userapp/providers/HistoryProvider.dart';
import 'package:bmsk_userapp/History/FilterUI.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:flutter/material.dart';
import 'package:bmsk_userapp/providers/NotificationProvider.dart';// as http;
import 'package:provider/provider.dart';

class PayBillHistory extends StatefulWidget {
  const PayBillHistory({super.key});
  @override
  State<PayBillHistory> createState() => _PayBillHistoryState();
}


class _PayBillHistoryState extends State<PayBillHistory> {
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
bool filterInit=false;
  //late List _bills;
  //Map _histories = {};
  //bool _isLoading = true;
  late String selected;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      String status = context.read<NotificationProvider>().failedBillCount>0?'failed':'pending';
      /*_histories[status]=await */context.read<HistoryProvider>().fetchPayBillHistory(status);
      //_bills =_histories[status];
      context.read<SocketProvider>().socket.emit('seen-failed-bill',  context.read<AuthProvider>().username);
    });
  }
  void handleFilter(String v) {context.read<HistoryProvider>().filterPayBillHistory(v);}
  void handleStatus(String v){
      /*selected=v;
      if(_histories.containsKey(v)){_bills=_histories[v];}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v);_bills=_histories[v];
      }*/context.read<HistoryProvider>().fetchPayBillHistory(v);
    //});
  }

  @override
  Widget build(BuildContext context) {
    final List billHistory = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Bill History'),
        actions: [IconButton(onPressed: (){context.read<HistoryProvider>().setFilterInit();}, icon: Icon(Icons.filter_list))],
      ),
      body: Stack(
        children:[
         Column(
          children: [
            if(context.watch<HistoryProvider>().filterInit) FilterUI(['pending','failed','success'],selected,handleStatus,handleFilter),
            Expanded(
              child: ListView.builder(
                itemCount: billHistory.length,
                itemBuilder: (context, index) {
                  final h= billHistory[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Row(children:[Row(children:[Text(h.acnumber),Text(h.type)]),Text('\u09F3$h.amount')], mainAxisAlignment:MainAxisAlignment.spaceBetween),
                        Row(children: [Text(h.date),Text('$h.status')], mainAxisAlignment:MainAxisAlignment.spaceBetween)
                    /*:*/ ]
                    ),
                  );
                },
              ),
            ),
          ],
          ),
          context.watch<HistoryProvider>().loading ? Center(child: CircularProgressIndicator()):Container()
        ]
      ));
  }
}

