import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/AppProvider.dart';
import '../Login.dart';
import 'Notification.dart';
import 'Security.dart';
/*StatelessWidget{
  @override
  Widget build (BuildContext context){
    v
  }
}import 'package:flutter/material.dart';

void main() => runApp(ProfileApp());

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Profile(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/


class Profile extends StatelessWidget {
  const Profile({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/user-profile-icon-circle_1256048-12499.jpg'), // Replace with actual image
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fajar Kun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                      Text('fajar123@gmail.com', style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.settings, color: Colors.grey[800]),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SummaryCard(title: 'Income', amount: '\$1.350,00', color: Colors.green,),
                  SummaryCard(title: 'Expense', amount: '\$350,00', color: Colors.red,),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SettingItem(icon: Icons.notifications, label: 'Notification', toGo: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));},),
                      SettingItem(icon: Icons.security, label: 'Security', toGo: (){Navigator.push(context, MaterialPageRoute(builder:(context)=>Security()));},),
                      ThemeSetting(icon: Icons.dark_mode, label: 'Dark Theme'),
                      //SettingItem(icon: Icons.chat_bubble, label: 'Contact Us', toGo: (){Navigator.push(context, );}),
                      SettingItem(icon: Icons.logout, label: 'Logout', isLogout: true, toGo: (){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('log out?'),
                            /*content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('This is a demo alert dialog.'),
                                  Text('Would you like to approve of this message?'),
                                ],
                              ),
                            ),*/
                            actions: <Widget>[
                              TextButton(
                                child: const Text('NO'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('YES'),
                                onPressed: () {
                                  Provider.of<AuthProvider>(context, listen: false).logout();
                                  Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                },
                              )
                            ],
                          );
                        },
                      );
                      },),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title, amount;
  final Color color;

  const SummaryCard({super.key, required this.title, required this.amount, required this.color,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.circle, color: color, size: 20),
          SizedBox(height: 8),
          Text(title),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        ],
      ),
    );
  }
}


class ThemeSetting extends StatefulWidget{
  final IconData icon;
  final String label;
  const ThemeSetting({super.key, required this.icon, required this.label});
  @override
  State<ThemeSetting> createState() => _ThemeSettingState();
}


class _ThemeSettingState extends State<ThemeSetting>{
  @override
  Widget build(BuildContext context) {
    final  app = context.watch<AppProvider>();
  
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(widget.icon, color: Colors.black),
      ),
      title: Text(widget.label, style: TextStyle(color: Colors.black),),
      trailing: Switch(value: app.isDarkTheme, onChanged: (_) {setState((){context.read<AppProvider>().toggleTheme();});}),
    );
  }
}



class SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function toGo;
  final bool isLogout;

  const SettingItem({super.key, required this.icon, required this.label, this.isLogout = false, required this.toGo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      ),
      title: Text(label, style: TextStyle(color: isLogout ? Colors.red : Colors.black),),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {toGo();},
    );
  }
}

/*class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Center(
        child: Text
    );
  }
}*/
