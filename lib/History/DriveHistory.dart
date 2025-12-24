import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/NotificationProvider.dart';
import '../providers/AuthProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/HistoryProvider.dart';
import '../widgets/Pages.dart';
import 'FilterUI.dart';
// as http;

class DriveHistory extends StatefulWidget {
  const DriveHistory({super.key});
  @override
  State<DriveHistory> createState() => _DriveHistory();
}


class _DriveHistory extends State<DriveHistory> {
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
  void filter (context,String v){context.read<HistoryProvider>().filterDriveHistory(v);}
  void handleStatus(context,String v){
      /*selected=v;
      if(_histories.containsKey(v)){_drives=_histories[v];}
      else{
        _histories[v]=context.read<HistoryProvider>().fetchDriveHistory(v);_drives=_histories[v];
      }*/
    context.read<HistoryProvider>().getDriveHistory();
    //});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String status=context.read<NotificationProvider>().failedDriveCount>0?'FAILED':'PENDING';selected=status;context.read<HistoryProvider>().changeStatus(status);
      /*_histories[status] =await */context.read<HistoryProvider>().getDriveHistory();
      //_drives=_histories[status];
      context.read<AppProvider>().socket.emit('seen-failed-drive',  context.read<AuthProvider>().username);
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>().history;
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
      ),//floatingActionButton:,
      body: Stack(
        children: [
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(context.watch<HistoryProvider>().filterInit) SizedBox(height:60,child:FilterUI(states:['pending','failed','success'],selected:selected,statusHandler:handleStatus,filterHandler:filter)/*TextField(
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
                    itemCount: history['drives']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final driveHistory = history['drives'];
                      if(driveHistory==null|| driveHistory.isEmpty) {return Center(child:Text('পাওয়া যায়নি'));}
                      final packHit = driveHistory[index];
                      if (searchQuery.isEmpty) {return packTile(packHit);}
                      //}
                      else if(packHit.values.any((value) => value.toLowerCase().contains(searchQuery))){return packTile(packHit);}
                        //return packTile(packHit);
                      else {return Text('পাওয়া যায়নি');}
                      //}
                    },
                  ),
                                          
                  ),
              ),
              if(history['pagination']['totalPage']>1) Pages(totalPage:history['pagination']['totalPage'],currentPage:history['pagination']['currentPage'],onPageChange:(p){context.read<HistoryProvider>().getDriveHistory(p);})
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
              Row(children:[Image.network(packHit['icon'],width:40, height:40, fit:BoxFit.contain),Text('Pack ID: ${packHit['recipient']}')]),
              Text('\u09F3 ${packHit['amount']}')
            ]
          ),
          Row(
            children:[
              Text(': ${packHit['id']}'),
              Text(': ${getStatus(packHit['status'],packHit['feedback'])}')
            ]
          ),
          Row(children: [Text(packHit['updatedAt'])],)
        ],
      ),
    );
  }
}

