import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/HistoryProvider.dart';
import '../providers/AuthProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/NotificationProvider.dart';
import '../widgets/Pages.dart';
import 'FilterUI.dart';


class TopupHistory extends StatefulWidget {
  const TopupHistory({super.key});
  @override
  State<TopupHistory> createState() => _TopupHistoryState();
}


class _TopupHistoryState extends State<TopupHistory> {
  //List<TopupHistory> _topups = [];
  String selected = 'failed';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().socket.emit('seen-failed-topup', {'userId': context.read<AuthProvider>().username});
      String status=context.read<NotificationProvider>().failedTopupCount>0?'FAILED':'SUCCESS';selected=status;context.read<HistoryProvider>().changeStatus(status);
      context.read<HistoryProvider>().getTopupHistory();
    });
  }
  
  void handleStatus(context,String v){context.read<HistoryProvider>().getTopupHistory();}
  void filter(context,String v){context.read<HistoryProvider>().filterTopupHistory(v);}

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title:Text('Topup History'),
        actions: [IconButton(onPressed:(){context.read<HistoryProvider>().setFilterInit();}, icon:Icon(Icons.filter_list)  )],
      ),//floatingActionButton:,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child:Column(children: [
              if(context.read<HistoryProvider>().filterInit) SizedBox(height:60,child:FilterUI(states:['failed','success'],selected:selected,statusHandler:handleStatus,filterHandler:filter)
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: history['topups']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final topupHistory = history['topups'];
                      if(topupHistory==null||topupHistory.isEmpty){return Center(child:Text('Not Found'));}
                      final topup = topupHistory[index];
                      return ListTile(
                        title: Row(children:[Image.network(topup['telecom']),Text(topup['recipient'])]),
                        subtitle: Text(topup['amount']),
                        trailing: Text(topup['updatedAt']),
                      );
                    },
                  ),
                            ),
              ),
            if(history['pagination']['totalPage']>1) Pages(totalPage:history['pagination']['totalPage'],currentPage:history['pagination']['currentPage'],onPageChange:(int p){context.read<HistoryProvider>().getTopupHistory(p);})
            ])
          )
        ]
      )
    );
  }
}

