import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'widgets/Mbank.dart';


class DBBL extends StatefulWidget {
  const DBBL({super.key});
  @override
  State<DBBL> createState() => _DBBLState();
}

class _DBBLState extends State<DBBL> {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return auth.authPrefs['accesses'].contains['dbbl']?Center(child:Text('এই মুহুরতে DBBL এর অনুমতি নেই')): Scaffold(
      appBar: AppBar(title:Text('DBBL')),
      body: Mbank(provider:'dbbl')
    );
  }
}