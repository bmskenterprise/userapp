import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/HistoryProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/NotificationProvider.dart';
import '../widgets/Pages.dart';
import 'FilterUI.dart';
//import 'package:bmsk_userapp/models/History/NagadHistory.dart';

class NagadHistory extends StatefulWidget {
  const NagadHistory({super.key});
  @override
  State<NagadHistory> createState() => _NagadHistoryState();
}


class _NagadHistoryState extends State<NagadHistory> {
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
  //List<NagadHistory> _history = [];
  //Map<String, List<NagadHistory>> _histories = {};
  String selected = 'pending';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String status = context.read<NotificationProvider>().failedNagadCount>0?'FAILED':'SUCCESS';selected=status;context.read<HistoryProvider>().changeStatus(status);
      /*_histories[status] =await */context.read<HistoryProvider>().getNagadHistory();
      //_history=_histories[status]!;
      context.read<AppProvider>().socket.emit('seen-nagad-failed',  context.read<AuthProvider>().username);//implement initState
    });
  }
  void filter(context,String query){context.read<HistoryProvider>().filterNagadHistory(query);}
void handleStatus(context,String v)  {
    /*selected=v;
      if(_histories.containsKey(v)){_history=_histories[v]!;}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchPayBillHistory(v) as List<NagadHistory>;
        _history=_histories[v]!;
      }*/context.read<HistoryProvider>().changeStatus(v);
    context.read<HistoryProvider>().getNagadHistory();
  //});
}
  @override
  Widget build(BuildContext context) {
    final /*List<dynamic>*/ history = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nagad History'),
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
                    itemCount: history['nagad']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final nagadHistory= history['nagad'];
                      if(nagadHistory==null||nagadHistory.isEmpty) {return Center(child:Text('Not Found'));}
                      final h= nagadHistory[index];
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
                              children: [Text(h['updatedAt']),Text('${h['status']}')], 
                            )
                        /*:*/ ]
                        ),
                      );
                    },
                  ),
                ),
              ),
              if(history['pagination']['totalPage']>1) Pages(totalPage:history['pagination']['totalPage'],currentPage:history['pagination']['currentPage'],onPageChange:(int p){context.read<HistoryProvider>().getNagadHistory(p);})
            ],
                   ),
         ),
        context.read<HistoryProvider>().loading ? Center(child: CircularProgressIndicator()): SizedBox.shrink(),
        ])
    );
  }
}

