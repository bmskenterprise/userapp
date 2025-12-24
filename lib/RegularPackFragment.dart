import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/AppProvider.dart';
import 'providers/TelecomProvider.dart';
import 'widgets/Pages.dart';
import 'RegularPack.dart';
//import 'package:http/http.dart' as http;
import 'widgets/Offline.dart';



class RegularPackFragment extends StatefulWidget {
  const RegularPackFragment({super.key});
  @override
  State<RegularPackFragment> createState() => _RegularPackFragmentState();
}


class _RegularPackFragmentState extends State<RegularPackFragment> {
  late String _selectedOperator;//_RegularPackFragment({super.key});
  //late Map<String,Map<String,String>> telecoms;
  final TextEditingController _controllerQuery = TextEditingController();
  //late Future<List<RegularPackFragment>> _regularPacksFuture;

  @override
  void initState() {
    super.initState();
    _selectedOperator=fetchLastUsedOpt().toString();//hiveBox=Hive.box('permission');//_regularPacksFuture =fetchRegularPacks() as Future<List<RegularPackFragment>>;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelecomProvider>().getRegularOpts();
    });
    //fetchRegularPacks() as Future<List<RegularPackFragment>>;
  }
  @override
  void dispose(){
    super.dispose();
    _controllerQuery.dispose();
    saveLastOpt(_selectedOperator);
  }
  /*getRegularOpts()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _selectedOperator=pref.getStringList('lastOpt')![2];
    context.read<ApiProvider>().fetchRegularPacks(_selectedOperator);_regularOpts=pref.getStringList('regular-opts')!;
  }*/
  Future<String> fetchLastUsedOpt()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList('lastOpt');
    return (list!=null&&list.length>2)?list[2]:'airtel';
  }
  Future<void> saveLastOpt(String opt)async{
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('lastOpt')??[];
    if(list.length>3) {
      while(list.length>3) {list.add('');}
    }
    list[2]=opt;
  }
  /*String getLastUsedOpt() async{
    String opt = await fetchLastUsedOpt();
    return opt;
}*/

  /*Future<List<Regular>> fetchRegularPacks() async {
    try{
    if(response.statusCode==200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Regular.fromJson(json)).toList();
    }}catch(e) {throw Exception('Failed to load regularpacks');}
  }*/

  @override
  Widget build(BuildContext context) {
    final isInternetConnected = context.watch<AppProvider>().isInternetConnected   ;
    final telecom=context.watch<TelecomProvider>();
    final regularData=telecom.regularPacksByOpt;
    final auth = context.watch<AuthProvider>();
    return /*!(auth.authPrefs['accesses']??[]).contains('regular')?Center(child:Text('এই মুহূর্তে রেগুলার অনুমতি নেই')):*/isInternetConnected?Stack(
      children:[
        Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'search drive',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                      ),
                      onChanged: (query){}
                    ),
                  ),
                  SizedBox(
                    width: 80,
                      child: DropdownButtonFormField(
                        value: _selectedOperator,
                        items: telecom.regularOpts/*context.read<OperatorListProvider>().getDriveOperators()*/.map<DropdownMenuItem<String>>((Map op) => DropdownMenuItem<String>(
                                    value: op['name'],
                                    child: Row(
                                      children: [
                                        Image.network(op['icon'],width:40,height:40),
                                        Text(op['name']),
                                      ],
                                    ),
                                  ),
                                ).toList(),
                        onChanged: (String? v) {
                            context.read<TelecomProvider>().onRegularOptChange(v!);//_selectedOperator = v!;
                            //_operator =context.read<OperatorListProvider>().operators.firstWhere((operator) => operator['name'] == _selectedOperator, orElse: () => null,);
                            //context.read<ApiProvider>().fetchDrivePacks(v);
                          //});
                        },
                      ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: telecom.loading?Center(child:CircularProgressIndicator()):ListView.builder(
                itemCount: regularData['regulars'].length,
                itemBuilder: (context,index){
                  final Map pack=regularData['regulars'][index];
                  if(_controllerQuery.text.isEmpty) {return RegularPack(pack:pack/*,opt:telecoms[_selectedOperator]*/);}
                  else if(pack['title'].toLowerCase().contains(_controllerQuery.text.toLowerCase())) {return RegularPack(pack:pack/*,opt:telecoms[_selectedOperator]*/);}
                  return null;
                }
              )
            ),
            /*FutureBuilder<List<Regular>>(
              future: _regularPacksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  return ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PackHit()),);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          height: 200,
                          child: Column(
                            children: [
                              // Text(data[index]['name']),
                              // Text(data[index]['name']),
                              // Text(data[index]['name']),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),*/
            if(regularData['pagination']['totalPage']>1) Pages(totalPage:regularData['pagination']['totalPage'],currentPage:regularData['pagination']['currentPage'],onPageChange:(int p){context.read<TelecomProvider>().getRegularPacks(p);})           //setState(() {
          ],
        ),
        if(telecom.loading) Center(child:CircularProgressIndicator())
    ]
    ):Offline();
  }
}