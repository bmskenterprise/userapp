import 'package:bmsk_userapp/RegularPackFragment.dart';
import 'package:flutter/material.dart';
import 'package:bmsk_userapp/DrivePackFragment.dart';


class PackScreen extends StatelessWidget{
  const PackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(//         .
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //  :          
          //           
          //         .
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //             
          bottom: TabBar(
            tabs: [Tab(text: "Regular"),Tab(text: "Drive")]
          )
          // title: Text(widget.title),
        ),
        body: TabBarView(
        // width: 300,
        // height: 300,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10)
        // ),
          children: [
          //
            RegularPackFragment(),
            DrivePackFragment()
          ]
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        //
        // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
        // action in the IDE, or press "p" in the console), to see the
        // wireframe for each widget.
        // mainAxisAlignment: MainAxisAlignment.center,
        // children: <Widget>[
        // const Icon(Icons.home),
        // Text(
        // 'flexiload',
        // style: Theme.of(context).textTheme.headlineMedium,
        // ),
        // ],
        // ),
        ),
        /*drawer: Drawer(
        // onPressed: _incrementCounter,
        // tooltip: 'Increment',
          child:  ListView(
            children: [
              DrawerHeader(child: Text("header")),
              ListTile(leading: Icon(Icons.home),title: Text(), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Page()))}),
              ListTile(leading: Icon(Icons.home),title: Text(), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Page()))}),
              ListTile(leading: Icon(Icons.home),title: Text(), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Page()))}),
              ListTile(leading: Icon(Icons.home),title: Text(), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Page()))}),
              ListTile(leading: Icon(Icons.home),title: Text(), onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Page()))})
            ],
          ),
        ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    )
    );
  }
}