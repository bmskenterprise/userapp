import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:bmsk_userapp/providers/OperatorListProvider.dart';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:bmsk_userapp/providers/TransferProvider.dart';
import 'package:bmsk_userapp/services/AuthService.dart';
import 'package:bmsk_userapp/History/History.dart';
import 'package:bmsk_userapp/Home/Home.dart';
import 'package:bmsk_userapp/Profile/Profile.dart';
import 'package:bmsk_userapp/Support/Index.dart';
import 'package:bmsk_userapp/providers/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});
  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  AuthService authService = AuthService();
  int _currentIndex = 0;
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
    initNotification();
    connectSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().getBalance(/*authService.getAuth() as String*/);
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
    socket = context.read<SocketProvider>().socket;
    List<String>?  authData = await authService.getAuth();
    socket.onConnect((_) {
      print('Connected to socket');
      // Register user with unique userId
      socket.emit('socket-session', authData?[0]);
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
      }); //this ID per user
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
        context.read<OperatorListProvider>().resetTopupOperators();
       }
      });
      socket.on('drive-opt-updated', (data){
       if(mounted) {
        context.read<OperatorListProvider>().resetDriveOperators();
       }
      });
      socket.on('regular-opt-updated', (data){
       if(mounted) {
        context.read<OperatorListProvider>().resetRegularOperators();
       }
      });
    });


    socket.on('notify', (data) {
      String title = data['title'] ?? 'Notification';
      String message = data['message'] ?? 'You have a new alert';
      showNotification(title, message);
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket');
    });
  }

  void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_id', 'Default Channel', importance: Importance.max, priority: Priority.high,);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics,);
  }


  List<Widget> screens = [HomeScreen(), HistoryScreen(), SupportScreen(), ProfileScreen()];
  /*List<Map> screens=[
    {'i':Icon(Icons.home),'l':'Home','w':HomeScreen()},
    {'i':Badge(position:BadgePosition.topEnd(top:0, end:3),badgeContent:Text(),child:Icon(Icons.history)),'l':'History','w':HistoryScreen()},
    {'i':Icon(Icons.help_outline),'l':'Support','w':SupportScreen()},
    {'i':Icon(Icons.person),'l':'Profile','w':ProfileScreen()}
  ];*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: /*screens.map((Map i)=>BottomNavigationBarItem(icon: i['i'],label: i['l'])).toList()*/[
          BottomNavigationBarItem(icon: Icon(Icons.home)/*, label: 'Home'*/),
          BottomNavigationBarItem(icon: Badge(position:BadgePosition.topEnd(top:0, end:3),badgeContent:Text(context.watch<NotificationProvider>().totalUnseenCount),child:Icon(Icons.bar_chart))/*, label: 'Activity'*/),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card)/*, label: 'My Card'*/),
          BottomNavigationBarItem(icon: Icon(Icons.person)/*, label: 'Profile'*/),
        ],
        onTap: (int index){
          setState((){
            _currentIndex = index;
          });
        }
    ));
  }
}