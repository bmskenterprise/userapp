import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  
import 'providers/AppProvider.dart';
import 'providers/ApiProvider.dart';
import 'providers/DepositProvider.dart' ;
import 'AddBalance.dart';
import 'BalanceTransfer.dart';
import 'Topup.dart';
import 'Pack.dart';
import 'Bkash.dart';
import 'DBBL.dart';
import 'PayBill.dart';
import 'Bank.dart';
import 'Nagad.dart';
import 'widgets/ImageSlider.dart';
import 'widgets/Offline.dart';





class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
//         .   , meaning
//             affect
//        .     in 
//              and
//        .      are
//   
/*           setState((){
           });
          
           setState((){
           });
          
           setState((){
           });*/



class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
/*final */double _dragOffset = 0.0;
  final double _maxDragDistance =150.0;
  late AnimationController _animationController;
  late Animation<double> _animation;//  switch(event) {     

  @override
  void initState() {
    super.initState(); 
    _animationController = AnimationController(
      duration: const Duration(milliseconds:300),
      vsync: this
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = context.read<ApiProvider>();// widgets.
      api.getSliderImages();api.getMbanks();
    });/*_internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event){
          case InternetStatus.connected:
             isConnectedToInternet = true;Toast();
          break;  
          case InternetStatus.disconnected:
             isConnectedToInternet = false;
          break;
          default:
             isConnectedToInternet = false;
          break; 
    })        */
  }//);
  @override
  void dispose(){       
    _animationController.dispose();
    super.dispose();
  }
  void _onVerticalDragUpdate(context,DragUpdateDetails details) {
    setState((){
      _dragOffset += details.delta.dy;
      if(_dragOffset<0) _dragOffset = 0;
      if(_dragOffset>_maxDragDistance) _dragOffset = _maxDragDistance;
    });/*final appRead = context.read<AppProvider>();
    final appWatch = context.watch<AppProvider>();
    appRead.setDragOffset(appWatch.dragOffset+details.delta.dy);
    if(appWatch.dragOffset<0) appRead.setDragOffset(0);
    if(appWatch.dragOffset>_maxDragDistance) appRead.setDragOffset(_maxDragDistance);*/
  }
  void _onVerticalDragEnd(context,DragEndDetails details){
    _animation = Tween<double>(
      begin:context.watch<AppProvider>().dragOffset,
      end:0.0
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      )
    )..addListener(() {
      context.read<AppProvider>().setDragOffset(_animation.value); //response = await http.get(
    });
  }

      /*if(response.statusCode==200) {
        //return data.map((json) => Operator.fromJson(json)).toList();
        _operators = data.map((json) => Operator.fromJson(json)).toList();
        notifyListeners();//});
        throw Exception('Failed to load operators');*/
    // This method is rerun every time setState is called, for instance as done
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final api = context.read<ApiProvider>(); //Uri.parse('https://bmsk-api.com/api/operators'),
    final balance = context.watch<DepositProvider>().balance;
    final isInternetConnected = app.isInternetConnected;
    double scaleFactor = 1.0 - (_dragOffset/_maxDragDistance) * 0.2;
    //List<Map<String,String>> mbanks = api.mbanks;
    //String? bkashIcon = mbanks.firstWhere((Map<String,String> m)=>m['name']=='bkash')['icon'];
    //String? dbblIcon = mbanks.firstWhere((Map<String,String> m)=>m['name']=='dbbl')['icon'];
    //String? nagadIcon = mbanks.firstWhere((Map<String,String> m)=>m['name']=='nagad')['icon'];// hot reload to see the AppBar
        // change color while the other colors stay the same.
    return isInternetConnected?
        /* TRY THIS: Try changing the color here to a specific color (to
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('widget.title'),
      ),*/
      /*bottomNavigationBar: BottomNavigationBar(
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
          }*/},),*/
      /*body:*/ Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child:Text('Yeah'))/*Stack(
          alignment:Alignment.topCenter,
          children: [
            Positioned(
              top:0,
              left:0,right: 0,
              child: Container(
                //width: double.infinity,
                height: 150,
                color: Colors.purple,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children:[
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[Text('Topup'),/*Text(balance['topup'].toString())*/]
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[Text('Drive'),/*Text(balance['drive'].toString())*/]
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[Text('Bank'),/*Text(balance['bank'].toString())*/]
                    )
                  ]
                ),
              ),
            ),
            Positioned(
              top:_dragOffset,
              left: 0,right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details){
                  _onVerticalDragUpdate(context,details);
                },
                onVerticalDragEnd: (DragEndDetails details){
                  _onVerticalDragEnd(context,details);
                },
                child:Transform.scale(
                  scale: scaleFactor,
                  child: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Container(
                          height: 180,
                          child: Row(children:[Column(children:[]),Center()]),
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10)
                                  // ),
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                            /*Navigator.push(
                                                                      MaterialPageRoute(builder: (context) => AddBalance()),
                                                                    );
                                                                  },*/
                                            /*Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => Send()),
                                                                    );
                                                                  },*/
                                          /*child: Container(
                                                                    width: 100,
                                                                    height: 100,*/
                                            /*Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => Password()),
                                                                    );
                                                                  },*/
                                              /*Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => Password()),
                                                                    );},*/
                                          Item(Icons.money,'Deposit',() {Navigator.push(context,MaterialPageRoute(builder: (context)=> AddBalance()));}),
                                          Item(Icons.send_rounded,'Send Balance',() {Navigator.push(context,MaterialPageRoute(builder: (context)=> BalanceTransfer()));}),
                                          Item(Icons.add_card,'Topup',() {Navigator.push(context,MaterialPageRoute(builder: (context)=> Topup()));}),
                                          Item(Icons.network_cell,'Packs',() {Navigator.push(context,MaterialPageRoute(builder: (context)=> Pack()));}),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                                            children:[Item(Icons.ac_unit,'Pay Bill',() {Navigator.push(context,MaterialPageRoute(builder: (context) => PayBill()));}),
                                              Item(Icons.ac_unit,'Bank',() {Navigator.push(context,MaterialPageRoute(builder: (context) => Bank()));}),
                                              /*MbankItem(bkashIcon,Bkash,() {Navigator.push(context,MaterialPageRoute(builder: (context) => Bkash()));}),
                                              MbankItem(dbblIcon,DBBL,() {Navigator.push(context,MaterialPageRoute(builder: (context) => DBBL()));})*/]),
                                              /*Row(
                                                mainAxisAlignment:MainAxit.spaceEvenly,
                                                children:[MbankItem(nagadIcon,Nagad,() {Navigator.push(context,MaterialPageRoute(builder: (context) => Nagad()));})
                                                ]
                                              )*/
                                      ],
                                    ),SizedBox(height: 100,),
                                    Expanded(
                                      //width: MediaQuery.of(context).size.width*0.9,height: 100,
                                      child:ImageSlider()
                                    ),
                                    /*Container(
                                      child: GridView(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1
                                        ),
                                        //children:
                                    )),*/
                                  ],
                                )),
                      ],
                    ),
                  ),
                )
              )
            )
          ],
        ),*/
      ):Offline();
      /*drawer: Drawer(
        // onPressed: _incrementCounter,
        // tooltip: 'Increment',
        child: ListView(
          children: [
            DrawerHeader(child: Text("header")),

            ListTile(
              leading: Icon(Icons.lock),
              title: Text("password"),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("pin"),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("profile"),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.power),
              title: Text("logout"),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Password()),
                );
              },
            ),
          ],
        ),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    
  }
}
  Widget Item(IconData icon,String text,goTo) {
    return GestureDetector(
      onTap: goTo,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(icon), Text(text)],
        ),
      ),
    );
  }
  
  Widget MbankItem(String icon,String text,goTo){
    return GestureDetector(
        onTap: goTo,
        child: SizedBox(
          width: 80,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Image.network(icon), Text(text)],
          ),
        ),
      );
  }
