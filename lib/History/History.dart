// import 'package:bmsk_userapp/HistoryList.dart';
import 'package:bmsk_userapp/History/PayBillHistory.dart';
import 'package:bmsk_userapp/History/TopupHistory.dart';
import 'package:bmsk_userapp/History/DriveHistory.dart';
import 'package:bmsk_userapp/History/DepositHistory.dart';
import 'package:bmsk_userapp/providers/HistoryProvider.dart';
import 'package:bmsk_userapp/providers/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*List<Map<String, dynamic>> historyItems= [
  {'label':'deposit', 'icon':Icon(Icons.home), 'widget':(context)=> DepositHistoryScreen()},
  {'label':'topup', 'icon':Icon(Icons.home), 'widget':(context)=> TopupHistory()},
  {'label':'drive', 'icon':Icon(Icons.home), 'widget':(context)=> PackHistoryScreen()},
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
      home: const HistoryScreen(),
    );
  }
}*/

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          /*bottom: TabBar(
            tabs: [
              Tab(text: 'topup'),
              Tab(text: 'pack'),
              Tab(text: 'add money'),
              Tab(text: 'transfer'),
            ],
          ),*/
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap:(){Navigator.push(context,MaterialPageRoute(builder:(_)=>ChangeNotifierProvider(create:(_)=>HistoryProvider(), child:DepositHistory())));},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text('Deposit',style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold),),
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
              )
            ],
          )
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
