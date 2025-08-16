import 'dart:async';

import 'package:http/http.dart' as http;

import '../Profile/Password.dart';
import '../AddBalance.dart';
import '../Send.dart';
import 'ImageSlider.dart';   
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  
import '../data_provider.dart';
import 'package:bmsk_userapp/Profile/Profile.dart';



class HomeScreen extends StatelessWidget {
// const HomePage({super.key, required this.title});
  const HomeScreen({super.key});
//         .   , meaning
//             affect
//        .     in 
//              and
//        .      are
//   

final bool isConnectedToInternet = false;

/*@override
State<HomeScreen> createState() => _HomeScreenState();
}*/

  StreamSubscription? _internetConnectionStreamSubscription = 0;

  void _initState() {
    super.initState(); 
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event){
        switch(event) {     
          case InternetStatus.connected:
           setState((){
             isConnectedToInternet = true;Toast();
           });
          break;  
          
          case InternetStatus.disconnected:
           setState((){
             isConnectedToInternet = false;
           });
          break;
          
          default:
           setState((){
             isConnectedToInternet = false;
           });
          break; 
    })        
  }//);
  void dispose  (){       
    _internetConnectionStreamSubscription?.cancel();
          super.dispose();
  }
Future<void> fetchOperators(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://bmsk-api.com/api/operators'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // return data.map((json) => Operator.fromJson(json)).toList();
        //setState(() {
        _operators = data.map((json) => Operator.fromJson(json)).toList();
        notifyListeners();
        //});
      } else {
        throw Exception('Failed to load operators');
      }
    } catch (err) {
      print(err);
    }
    // Set data in provider
    Provider.of<DataProvider>(context, listen: false)
        .setData(countFromServer, itemsFromServer);
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('widget.title'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'My Card'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index){
          /*switch(index){
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => Activity()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyCard()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
          }*/
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // height: 300,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10)
        // ),
        children: [
          Container(
            child: Column(
              children: [
                Row(children: [Column(children: []), Center()]),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddBalance()),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Icon(Icons.money), Text('Add Balance')],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Send()),
                        );
                      },
                      /*child: Container(
                        width: 100,
                        height: 100,*/
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded),
                            Text('Send Money'),
                          ],
                        ),
                      //),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Password()),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Icon(Icons.person_add), Text('Add User')],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Password()),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Icon(Icons.person), Text('Users')],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ImageSlider(),
          Container(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1
              ),
              children:
          )),
        ],
      )),
      drawer: Drawer(
        // onPressed: _incrementCounter,
        // tooltip: 'Increment',
        child: ListView(
          children: [
            DrawerHeader(child: Text("header")),

            ListTile(
              leading: Icon(Icons.lock),
              title: Text("password"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("pin"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.power),
              title: Text("logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
