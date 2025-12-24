import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/HistoryProvider.dart';
import '../providers/AuthProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/NotificationProvider.dart';
import '../widgets/Pages.dart';// http;
import 'FilterUI.dart';

class PayBillHistory extends StatefulWidget {
  const PayBillHistory({super.key});
  @override
  State<PayBillHistory> createState() => _PayBillHistoryState();
}


class _PayBillHistoryState extends State<PayBillHistory> {
dynamic getStatus(status,feedback) {
    dynamic state;
    switch(status) {
      case 'PENDING':
        state= Icon(Icons.pending,color:Colors.cyan);break;
      case 'COMPLETED':
        state= Icon(Icons.check_circle,color:Colors.green);break;
      case 'FAILED':
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String status = context.read<NotificationProvider>().failedBillCount>0?'FAILED':'PENDING';
      /*_histories[status]=await */context.read<HistoryProvider>().changeStatus(status);context.read<HistoryProvider>().getPayBillHistory();
      //_bills =_histories[status];
      context.read<AppProvider>().socket.emit('seen-failed-bill',  context.read<AuthProvider>().username);
    });
  }
  void filter(context,String v) {context.read<HistoryProvider>().filterPayBillHistory(v);}
  void handleStatus(context,String v){
      /*selected=v;
      if(_histories.containsKey(v)){_bills=_histories[v];}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v);_bills=_histories[v];
      }*/context.read<HistoryProvider>().getPayBillHistory();
    //});
  }

  @override
  Widget build(BuildContext context) {
    final  history = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Bill History'),
        actions: [IconButton(onPressed: (){context.read<HistoryProvider>().setFilterInit();}, icon: Icon(Icons.filter_list))],
      ),//floatingActionButton:,
      body: Stack(
        children:[
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
            children: [
              if(context.watch<HistoryProvider>().filterInit) SizedBox(height:60,child:FilterUI(states:['pending','failed','success'],selected:selected,statusHandler:handleStatus,filterHandler:filter)
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: history['bills']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final billHistory= history['bills'];
                      if(billHistory==null||billHistory.isEmpty) {return Center(child:Text('Not Found'));}
                      final h=billHistory[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        child:Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children:[Row(children:[Text(h['acNumber']),Text(h['type'])]),Text('\u09F3${h['amount']}')],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [Text(h['date']),Text(h['status'])],
                            )
                        /*:*/ ]
                        ),
                      );
                    },
                  ),
                ),
              ),
              if(history['pagination']['totalPage']>1) Pages(totalPage:history['pagination']['totalPage'],currentPage:history['pagination']['currentPage'],onPageChange:(p){context.read<HistoryProvider>().getDepositHistory(p);})
            ],
            ),
         ),
          if(context.watch<HistoryProvider>().loading) Center(child:CircularProgressIndicator()) //Center(child: CircularProgressIndicator()):Container()
        ]
      ));
  }
}

