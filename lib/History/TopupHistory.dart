import 'package:bmsk_userapp/providers/HistoryProvider.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:flutter/material.dart';
import 'package:bmsk_userapp/History/FilterUI.dart';
import 'package:bmsk_userapp/providers/NotificationProvider.dart';// http;
import 'package:provider/provider.dart';


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
      context.read<SocketProvider>().socket.emit('seen-failed-topup', {'userId': context.read<AuthProvider>().username});
      String status=context.read<NotificationProvider>().failedTopupCount>0?'failed':'success';selected=status;
      context.read<HistoryProvider>().fetchTopupHistory(status);
    });
  }
  
  void handleStatus(String v){context.read<HistoryProvider>().fetchTopupHistory(v);}
  void handleFilter(String v){context.read<HistoryProvider>().filterTopupHistory(v);}

  @override
  Widget build(BuildContext context) {
    final topupHistory = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title:Text('Topup History'),
        actions: [IconButton(onPressed:(){context.read<HistoryProvider>().setFilterInit();}, icon:Icon(Icons.filter_list)  )],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child:Column(children: [
              if(context.read<HistoryProvider>().filterInit) FilterUI(['failed','success'],selected,handleStatus,handleFilter),
              Expanded(
                child: ListView.builder(
                  itemCount: topupHistory.length,
                  itemBuilder: (context, index) {
                    final /*TopupHistory*/ topup = topupHistory[index];
                    return ListTile(
                      title: Row(children:[Image.network(topup.telecom),Text(topup.recipient)]),
                      subtitle: Text(topup.amount),
                      trailing: Text(topup.date),
                    );
                  },
                ),
            )
            ])
          )
        ]
      )
    );
  }
}

