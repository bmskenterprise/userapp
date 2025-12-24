import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'providers/AppProvider.dart';
import 'services/AuthService.dart';
import 'providers/DepositProvider.dart';
import 'providers/TelecomProvider.dart';
import 'providers/AuthProvider.dart';
import 'providers/NotificationProvider.dart';
import 'History/History.dart';
import 'Home.dart';
import 'Profile/Profile.dart';
import 'Support/Index.dart';

class Index extends StatefulWidget {
  const Index({super.key});
  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  AuthService authService = AuthService();
  //int _currentIndex = 0;
  int totalFailedCount = 0;
late IO.Socket socket;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /*Future<Map<String, String?>> getAuth()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {'user':prefs.getString('user'),'token':prefs.getString('token')} /*?? 'user'*/;
  }*/

  @override
  void initState() {
    super.initState();
    //initNotification();
    //connectSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepositProvider>().getBalance(/*authService.getAuth() as String*/);
      context.read<AuthProvider>().getAuth();
    });
  }

  @override
  void dispose() {
    socket.off('deposit-failed');
    socket.off('topup-failed');
    socket.off('drive-failed');
    socket.off('regular-failed');
    socket.off('bank-failed');
    socket.off('bill-failed');
    socket.off('opt-updated');
    socket.off('topup-opt-updated');
    socket.off('drive-opt-updated');
    socket.dispose();
    super.dispose();
  }

  void initNotification() {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: androidSettings),);
  }

  void connectSocket()async {
    socket = context.read<AppProvider>().socket;
    Map  authData = await authService.getAuth();
    socket.onConnect((_) {
      print('Connected to socket');
      // Register user with unique userId
      socket.emit('socket-session', authData['user'][0]);
      socket.on('deposit-failed', (data){
       if(mounted) {
        context.read<NotificationProvider>().unseenDepositCount(data.failedDepositCount);//totalFailedCount+=data.failedDepositCount;
       }
      });
      socket.on('topup-failed', (data){
       if(mounted) {
        context.read<NotificationProvider>().unseenTopupCount(data.failedTopupCount);//totalFailedCount+=data.failedCount
       }
      });
      socket.on('drive-failed', (data){
       if(mounted) {
        context.read<NotificationProvider>().unseenDriveCount(data.failedDriveCount);
       }
      });
      socket.on('regular-failed', (data){
       if(mounted) {
        context.read<NotificationProvider>().unseenRegularCount(data.failedRegularCount);//totalFailedCount+=data.failedCount
       }
      });
      socket.on('bill-failed', (data){
       if(mounted) {
        context.read<NotificationProvider>().unseenBillCount(data.failedBillCount);
       }
      });
      socket.on('bank-failed', (data){
       if(mounted) {
        context.read<NotificationProvider>().unseenBankCount(data.failedBankCount);
       }
      });
      socket.on('topup-opt-updated', (data){
       if(mounted) {
        context.read<TelecomProvider>().resetTopupOperators();
       }
      });
      socket.on('drive-opt-updated', (data){
       if(mounted) {
        context.read<TelecomProvider>().resetDriveOperators();
       }
      });
      socket.on('regular-opt-updated', (data){
       if(mounted) {
        context.read<TelecomProvider>().resetRegularOperators();
       }
      });
    });


    socket.on('notify', (data) {
      String title = data['title'] ?? 'Notification';
      String message = data['message'] ?? 'You have a new alert';
      showNotification(title, message);
    });

    socket.on('notice', (data) {
      String title = data['title'] ?? 'Notification';
      String message = data['message'] ?? 'You have a new alert';
      if(data['receiveMedium'].contains('push')) showNotification(title, message);
      if(data['receiveMedium'].contains('in-app')){
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      }
    });

    /*socket.onDisconnect((_) {
      print('Disconnected from socket');
    });*/
  }

  void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_id', 'Default Channel', importance: Importance.max, priority: Priority.high,);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics,);
  }


  List<Widget> screens = [Home(), History(), Support(), Profile()];
  /*List<Map> screens=[
    {'i':Icon(Icons.home),'l':'Home','w':Home()},
    {'i':Badge(position:BadgePosition.topEnd(top:0, end:3),badgeContent:Text(),child:Icon(Icons.history)),'l':'History','w':History()},
    {'i':Icon(Icons.help_outline),'l':'Support','w':Support()},
    {'i':Icon(Icons.person),'l':'Profile','w':Profile()}
  ];*/

  @override
  Widget build(BuildContext context) {
    final unseenCount = context.watch<NotificationProvider>().totalUnseenCount; //ID per user
    final app = context.watch<AppProvider>();   //
    return Scaffold(
      body: IndexedStack(
        index: app.indexBottomNavBar,
        children: screens
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: app.indexBottomNavBar,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: /*screens.map((Map i)=>BottomNavigationBarItem(icon: i['i'],label: i['l'])).toList()*/[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: badges.Badge(position:badges.BadgePosition.topEnd(top:0, end:3),badgeContent:Text(unseenCount.toString()),child:Icon(Icons.history)), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Support'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (int index){
          context.read<AppProvider>().setCurrentBottomNavBarIndex(index);
            //_currentIndex = index;
        }
    ));
  }
}