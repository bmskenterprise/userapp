import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/HistoryProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/NotificationProvider.dart';
import '../widgets/Pages.dart';
import 'FilterUI.dart';
//import 'package:bmsk_userapp/models/History/DBBLHistory.dart';

class DBBLHistory extends StatefulWidget {
  const DBBLHistory({super.key});
  @override
  State<DBBLHistory> createState() => _DBBLHistoryState();
}


class _DBBLHistoryState extends State<DBBLHistory> {
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
  //List<DBBLHistory> _history = [];
  //Map<String, List<DBBLHistory>> _histories = {};
  String selected = 'pending';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String status = context.read<NotificationProvider>().failedDBBLCount>0?'FAILED':'SUCCESS';selected=status;context.read<HistoryProvider>().changeStatus(status);
      /*_histories[status] =await */context.read<HistoryProvider>().getDBBLHistory();
      //_history=_histories[status]!;
      context.read<AppProvider>().socket.emit('seen-dbbl-failed',  context.read<AuthProvider>().username);//implement initState
    });
  }
  void filter(context,String query){context.read<HistoryProvider>().filterDBBLHistory(query);}
void handleStatus(context,String v)  {
    /*selected=v;
      if(_histories.containsKey(v)){_history=_histories[v]!;}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v) as List<DBBLHistory>;
        _history=_histories[v]!;
      }*/context.read<HistoryProvider>().changeStatus(v);
    context.read<HistoryProvider>().getDBBLHistory();
  //});
}
  @override
  Widget build(BuildContext context) {
    final /*List<dynamic>*/ history = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title: Text('DBBL History'),
        actions: [IconButton(onPressed: (){context.read<HistoryProvider>().setFilterInit();}, icon: Icon(Icons.filter_list))],
      ),
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
                    itemCount: history['dbbl']?.length??0,
                    itemBuilder: (context, index) {
                      final dbblHistory= history['dbbl'];
                      if(dbblHistory==null||dbblHistory.isEmpty) {return Center(child:Text('Not Found'));}
                      final h= dbblHistory[index];
                      return Container(
                        child:Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children:[Row(children:[Text(h['acNumber']),Text(h['recipient'], style:TextStyle(fontSize:12))]),Text('\u09F3${h['amount']}')],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [Text(h['updatedAt']),Text(h['status'])], 
                            )
                        /*:*/ ]
                        ),
                      );
                    },
                  ),
                ),
              ),
              if(history['pagination']['totalPage']>1) Pages(totalPage:history['pagination']['totalPage'],currentPage:history['pagination']['currentPage'],onPageChange:(int p){context.read<HistoryProvider>().getDBBLHistory(p);})
            ],
                   ),
         ),
        context.read<HistoryProvider>().loading ? Center(child: CircularProgressIndicator()): SizedBox.shrink(),
        ])
    );
  }
}

