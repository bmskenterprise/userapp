import 'dart:convert';
import 'package:bmsk_userapp/providers/SocketProvider.dart';
import 'package:bmsk_userapp/Pack.dart';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/providers/ApiProvider.dart';
import 'package:bmsk_userapp/providers/OperatorListProvider.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'PackHit.dart';
import 'models/Drive.dart';
import 'models/Operator.dart';
// ignore: file_names

class DrivePackFragment extends StatefulWidget {
  const DrivePackFragment({super.key});
  @override
  State<DrivePackFragment> createState() => _DrivePackFragmentState();
}




class _DrivePackFragmentState extends State<DrivePackFragment> {
  List allPacks = [];
  Map _all = {};
  List _packs = [];
  //late Future<List<Drive>> _drivePacksFuture;
  String _selectedOperator = '';/*Map*/List _operators =[] /*{}*/;
  final TextEditingController _queryController = TextEditingController();
  // late Future<List<Operator>> _operatorsFuture;

  @override
  void initState() {
    super.initState();
    /*_operatorsFuture = */
    //fetchOperators();
    /*_drivePacksFuture =*/WidgetsBinding.instance.addPostFrameCallback((_) {
      final socket=context.read<SocketProvider>().socket;
      socket.on('drive-opt',(data){if(mounted) context.read<OperatorListProvider>().getDriveOperators();});
    });getDriveOpts();
  }
  getDriveOpts()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _selectedOperator=pref.getStringList('lastOpt')![0];
    context.read<ApiProvider>().fetchDrivePacks(_selectedOperator);_operators=pref.getStringList('drive-opts')!;
  }
  
  @override
  Widget build(BuildContext context) {
  //List<Operator> _operators = Provider.of<OperatorProvider>(context).operators;
    final List packs= context.watch<ApiProvider>().currentDrivePacks;
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 150),
          // height: 80,
          child: Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'search drive',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  onChanged: (query) {
                    if (query.isEmpty) {
                      print('empty');
                      //suggestions = _all[_selectedOperator];
                    } else {
                      //suggestions =_countries.where((c)=> c.name.toLowerCase().contains(query.toLowerCase(),)).toList();
                    }
                    //setState(() => _countries = suggestions);
                  },
                ),
              ),
              SizedBox(
                child: DropdownButtonFormField(
                  value: _selectedOperator,
                  items: _operators/*context.read<OperatorListProvider>().getDriveOperators()*/.map<DropdownMenuItem<String>>((op) => DropdownMenuItem<String>(
                              value: op.name,
                              child: Row(
                                children: [
                                  Image.network(op.icon),
                                  Text(op.name),
                                ],
                              ),
                            ),
                          ).toList(),
                  onChanged: (String? v) {
                    //setState(() {
                      _selectedOperator = v!;
                      //_operator =context.read<OperatorListProvider>().operators.firstWhere((operator) => operator['name'] == _selectedOperator, orElse: () => null,);
                      context.read<ApiProvider>().fetchDrivePacks(v);
                    //});
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: context.watch<OperatorListProvider>().loading?Center(child:CircularProgressIndicator()):ListView.builder(
            itemCount: packs.length,
            itemBuilder: (context, index) {
              final Map pack = packs[index];
              if (_queryController.text.isEmpty) {
                return Pack(pack: pack,opt:_operator);
              } else if (pack['title'].toLowerCase().contains(_queryController.text.toLowerCase())) {
                return Pack(pack: pack,opt:_operator);
              }
            },
          ),
        ),
      ],
    );
  }
}
