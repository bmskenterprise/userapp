import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/Pages.dart';
import 'providers/AppProvider.dart';
import 'DrivePack.dart';
//import 'package:bmsk_userapp/Toast.dart';
import 'providers/TelecomProvider.dart';
import 'providers/AuthProvider.dart';
// ignore: depend_on_referenced_packages
//import 'package:http/http.dart' as http;
//import 'package:socket_io_client/socket_io_client.dart';
import 'widgets/Offline.dart';
//import 'models/Drive.dart';
//import 'models/Operator.dart';
// ignore: file_names

class DrivePackFragment extends StatefulWidget {
  const DrivePackFragment({super.key});
  @override
  State<DrivePackFragment> createState() => _DrivePackFragmentState();
}




class _DrivePackFragmentState extends State<DrivePackFragment> {
  List allPacks = [];
  late Map<String,Map<String,String>> telecoms;
  late Map authPrefs;
  //List _packs = [];
  //late Future<List<Drive>> _drivePacksFuture;
 late String _selectedOperator/* = 'airtel'*/;/*Map*///late List<Map> _driveOpts /*{}*/;
  final TextEditingController _queryController = TextEditingController();
  // late Future<List<Operator>> _operatorsFuture;

  @override
  void initState() {
    super.initState();
    _selectedOperator=getLastUsedOpt().toString();//fetchOperators();
    /*_drivePacksFuture =*/WidgetsBinding.instance.addPostFrameCallback((_) {
      context.watch<TelecomProvider>().getDriveOpts();
      /*final*/ 
      /*socket.on('drive-opt',(data){
        if(mounted) context.read<OperatorListProvider>().getDriveOperators();
      });*/
    });
  }
  @override
  void dispose(){
    super.dispose();
    _queryController.dispose();
    saveLastOpt(_selectedOperator);
  }
  /*getDriveOpts()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _selectedOperator=pref.getStringList('lastOpt')![1];
    context.read<ApiProvider>().fetchDrivePacks(_selectedOperator);_driveOpts=pref.getStringList('drive-opts')!;
  }*/
  Future<String> getLastUsedOpt()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList('lastOpt');
    return (list!=null&&list.length>1)?list[1]:'airtel';
  }
  Future<void> saveLastOpt(String opt)async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList('lastOpt')??[];
    if(list.length<2){
      while(list.length<2){list.add('');}
    }
    list[1]=opt;
  }
  @override
  Widget build(BuildContext context) {
  bool isInternetConnected = Provider.of<AppProvider>(context).isInternetConnected;
    final telecom = context.watch<TelecomProvider>();
    final auth=context.read<AuthProvider>();
    final driveData=telecom.drivePacksByOpt;
    return !auth.authPrefs['accesses'].contains('drive')?Center(child:Text('')):isInternetConnected?Stack(
      children:[
        Column(
      children: [
        SizedBox(
          //constraints: const BoxConstraints(maxHeight: 150),
           height: 60,
          child: Row(
            children: [
              Expanded(
                //width: 300,
                child: TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(
                    hintText: 'search drive',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  onChanged: (query) {
                    if (query.isNotEmpty) context.read<TelecomProvider>().filterDrive(query);
                      //print('empty');
                      //suggestions = _all[_selectedOperator];
                    /*} else {
                      //suggestions =_countries.where((c)=> c.name.toLowerCase().contains(query.toLowerCase(),)).toList();
                    }*/
                    //setState(() => _countries = suggestions);
                  },
                ),
              ),
              SizedBox(
                width: 80,
                child: DropdownButtonFormField(
                  value: _selectedOperator,
                  items: telecom.driveOpts/*context.read<OperatorListProvider>().getDriveOperators()*/.map<DropdownMenuItem<String>>((Map op) => DropdownMenuItem<String>(
                              value: op['name'],
                              child: Row(
                                children: [
                                  Image.network(op['icon']),
                                  Text(op['name']),
                                ],
                              ),
                            ),
                          ).toList(),
                  onChanged: (String? v) {
                    //setState(() {
                      context.read<TelecomProvider>().onDriveOptChange(v!);//_selectedOperator = v!;
                      //_operator =context.read<OperatorListProvider>().operators.firstWhere((operator) => operator['name'] == _selectedOperator, orElse: () => null,);
                      //context.read<TelecomProvider>().getDrivePacks(v);
                    //});
                  },
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: telecom.loading?Center(child:CircularProgressIndicator()):ListView.builder(
            itemCount: driveData['drives'].length,
            itemBuilder: (context, index) {
              final Map pack = driveData['drives'][index];
              if (_queryController.text.isEmpty) {return DrivePack(pack:pack/*, opt:telecoms[_selectedOperator]*/);}
               else if (pack['title'].toLowerCase().contains(_queryController.text.toLowerCase())) {return DrivePack(pack: pack/*,opt:_operator*/);}
                return null; //pack/*,opt:_operator*/);
              //}
            },
          ),
        ),
        if(driveData['pagination']['totalPage']>1) Pages(totalPage:driveData['pagination']['totalPage'],currentPage:driveData['pagination']['currentPage'],onPageChange:(int p){context.read<TelecomProvider>().getDrivePacks(p);})       //return Pack(pack: pack,opt:_operator);
      ],
    ),
    if(telecom.loading) Center(child:CircularProgressIndicator())
    ]):Offline();
  }
}
