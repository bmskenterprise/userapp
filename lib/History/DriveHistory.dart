import 'package:bmsk_userapp/providers/NotificationProvider.dart';
import 'package:bmsk_userapp/History/FilterUI.dart';
import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:bmsk_userapp/providers/HistoryProvider.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PackHistoryScreen extends StatefulWidget {
  const PackHistoryScreen({super.key});
  @override
  State<PackHistoryScreen> createState() => _PackHistoryScreen();
}


class _PackHistoryScreen extends State<PackHistoryScreen> {
  String searchQuery = '';String selected='pending';
  //List _drives = [];//late Map _histories;
  bool searchInit = false;
  Widget getStatus(status,feedback) {
    Widget state;
    switch(status) {
      case 'pending':
        state= Icon(Icons.pending,color:Colors.cyan);break;
      case 'failed':
        state= Text(feedback, style:TextStyle(color:Colors.red),);break;
      case 'success':
        state= Icon(Icons.check_circle,color:Colors.green);break;
      default:
        state=Text('unknown status');break;
    }
    return state;
  }
  void handleFilter (String v){context.read<HistoryProvider>().filterDriveHistory(v);}
  void handleStatus(String v){
      /*selected=v;
      if(_histories.containsKey(v)){_drives=_histories[v];}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchDriveHistory(v);_drives=_histories[v];
      }*/
    context.read<HistoryProvider>().fetchDriveHistory(v);
    //});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      String status=context.read<NotificationProvider>().failedDriveCount>0?'failed':'pending';selected=status;
      /*_histories[status] =await */context.read<HistoryProvider>().fetchDriveHistory(status);
      //_drives=_histories[status];
      context.read<SocketProvider>().socket.emit('seen-failed-drive',  context.read<AuthProvider>().username);
    });
  }

  @override
  Widget build(BuildContext context) {
    final driveHistory = context.watch<HistoryProvider>().history;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pack History"),
        actions: [
          IconButton(
            onPressed: (){
              context.read<HistoryProvider>().setFilterInit();
            },
            icon: Icon(Icons.search)
          )
        ],
      ),
      body: Stack(
        children: [
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(context.watch<HistoryProvider>().filterInit) FilterUI(['pending','failed','success'],selected,handleStatus,handleFilter)/*TextField(
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
                  itemCount: driveHistory.length,
                  itemBuilder: (context, index) {
                    final packHit = driveHistory[index];
                    if (searchQuery.isEmpty) {
                      return packTile(packHit);
                    }
                    else if(packHit.values.any((value) => value.toLowerCase().contains(searchQuery))){
                      return packTile(packHit);
                    }else{
                      return Text('পাওয়া যায়নি');
                    }
                  },
                ),
                                        
                ),
              
            ],
          ),
        ),
        context.watch<HistoryProvider>().loading ? Center(child: CircularProgressIndicator()): Container()
        ]
      )
    );
  }
  Widget packTile(packHit){
    return Container(
      child: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Row(children:[Image.network(packHit['icon'],width:40, height:40, fit:BoxFit.contain),Text('Pack ID: ${packHit.recipient}')]),
              Text('\u09F3 ${packHit.amount}')
            ]
          ),
          Row(
            children:[
              Text(': ${packHit.id}'),
              Text(': ${getStatus(packHit.status,packHit.feedback)}')
            ]
          ),
          Row(children: [Text(packHit.date)],)
        ],
      ),
    );
  }
}

