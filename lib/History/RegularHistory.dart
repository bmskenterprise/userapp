import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/AppProvider.dart';
import '../providers/NotificationProvider.dart';
import '../providers/HistoryProvider.dart';
//import 'package:http/http.dart' as http;
import '../widgets/Pages.dart';                                       
import 'FilterUI.dart';

class RegularHistory extends StatefulWidget {
  const RegularHistory({super.key});
  @override
  State<RegularHistory> createState() => _RegularHistory();
}


class _RegularHistory extends State<RegularHistory> {
  String searchQuery = '';String selected='pending';
  List _regulars = [];late Map _histories;
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
  void filter(context,String v){context.read<HistoryProvider>().filterRegularHistory(v);}
  void handleStatus(context,String v){
    setState(() {
      selected=v;
      if(_histories.containsKey(v)){_regulars=_histories[v];}
      else{
        _histories[v]=context.read<HistoryProvider>().getRegularHistory();_regulars=_histories[v];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String status=context.read<NotificationProvider>().failedDriveCount>0?'FAILED':'PENDING';
      /*_histories[status] =await */context.read<HistoryProvider>().changeStatus(status);context.read<HistoryProvider>().getRegularHistory();
      _regulars=_histories[status];
      context.read<AppProvider>().socket.emit('seen-regular-failed',  context.read<AuthProvider>().username);
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>().history;             //}
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pack History"),
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                searchInit=!searchInit;
              });
            },
            icon: Icon(Icons.search)
          )
        ],
      ),//floatingActionButton:,
      body: context.watch<HistoryProvider>().loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(searchInit) FilterUI(states:['pending','failed','success'],selected:selected,statusHandler:handleStatus,filterHandler:filter),/*TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (String v){
                  setState((){
                    searchQuery = v.toString();
                  });
                },
              )*/
              Expanded(
                child: ListView.builder(
                  itemCount: _regulars.length,
                  itemBuilder: (context, index) {
                    final packHit = _regulars[index];
                    if (searchQuery.isEmpty) {
                      return packTile(packHit);
                    }
                    else if(packHit.values.any((value) => value.toLowerCase().contains(searchQuery))){
                      return packTile(packHit);
                    }else {return Text('পাওয়া যায়নি');}
                      //return Text('পাওয়া যায়নি');
                  },
                ),
                ),
              if(history['pagination'].totalPage>1) Pages(totalPage:history['pagination'].totalPage,currentPage:history['pagination'].currentPage,onPageChange:(int p){context.read<HistoryProvider>().getRegularHistory(p);})
            ],
          ),
        ),
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
              Text(': ${packHit['date']}'),
              Text(': ${getStatus(packHit['status'],packHit['feedback'])}')
            ]
          ),
        ],
      ),
    );
  }
}

class Pack {
  final String id;
  final String amount;
  final String date;
  final String number;

  Pack({
    required this.id,
    required this.amount,
    required this.date,
    required this.number,
  });

  factory Pack.fromJson(Map<String, dynamic> json) {
    return Pack(
      id: json['id'],
      amount: json['amount'],
      date: json['date'],
      number: json['number'],
    );
  }
}
