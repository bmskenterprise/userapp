import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '/HistoryList.dart';
import '../providers/HistoryProvider.dart';
import '../providers/NotificationProvider.dart';
import 'DepositHistory.dart';
import 'TopupHistory.dart';
import 'DriveHistory.dart';
import 'RegularHistory.dart';
import 'PayBillHistory.dart';
import 'BankHistory.dart';
import 'BkashHistory.dart';
import 'DBBLHistory.dart';
import 'NagadHistory.dart';

/*List<Map<String, dynamic>> historyItems= [
  {'label':'deposit', 'icon':Icon(Icons.home), 'widget':(context)=> DepositHistory()},
  {'label':'topup', 'icon':Icon(Icons.home), 'widget':(context)=> TopupHistory()},
  {'label':'drive', 'icon':Icon(Icons.home), 'widget':(context)=> PackHistory()},
  {'label':'regular', 'icon':Icon(Icons.home), 'widget':(context)=> BalanceHistory()}
];*/
/*void main() {
  runApp(const MyApp());
}*/
/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const History(),
    );
  }
}*/

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History') 
          /*bottom: TabBar(
            tabs: [Tab(text:'topup'),Tab(text:'pack'),Tab(text:'add money'),Tab(text:'transfer')],
          ),*/
               
               
                
               
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:DepositHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Deposit',style: TextStyle(fontSize:20,  fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedDriveCount>0)Text(context.read<NotificationProvider>().failedDriveCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height:30),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:TopupHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Topup',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedTopupCount>0)Text(context.read<NotificationProvider>().failedTopupCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height:30),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:DriveHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Drive',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedDriveCount>0)Text(context.read<NotificationProvider>().failedDriveCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height:30),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:RegularHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Regular',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedRegularCount>0)Text(context.read<NotificationProvider>().failedRegularCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height:30),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:PayBillHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Bill',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedBillCount>0)Text(context.read<NotificationProvider>().failedBillCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height:30),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:BankHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Bank',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedBankCount>0)Text(context.read<NotificationProvider>().failedBankCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height: 40,),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:BkashHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Bkash',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedBankCount>0)Text(context.read<NotificationProvider>().failedBankCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height: 40,),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:DBBLHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('DBBL',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedBankCount>0)Text(context.read<NotificationProvider>().failedBankCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),SizedBox(height: 40,),
                GestureDetector(
                  onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:NagadHistory())));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Nagad',style: TextStyle(fontSize:20, fontWeight:FontWeight.bold),),
                      if(context.read<NotificationProvider>().failedBankCount>0)Text(context.read<NotificationProvider>().failedBankCount.toString(), style:TextStyle(color:Colors.red))
                    ]
                  ),
                ),
              ],
            )
          ),
        )/*GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: historyItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index){
            final item = historyItems[index];
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> item['widget'](context)));
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [item['icon'],item['label']],
                ),
              ),
            );
          },
        ),*/
      ),
    );
  }
}
