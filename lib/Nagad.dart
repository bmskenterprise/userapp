import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'widgets/Mbank.dart';


class Nagad extends StatefulWidget {
  const Nagad({super.key});
  @override
  State<Nagad> createState() => _NagadState();
}

class _NagadState extends State<Nagad> {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return auth.authPrefs['accesses'].contains['nagad']?Center(child:Text('এই মুহূর্তে Nagad এর অনুমতি নেই')): Scaffold(
      appBar: AppBar(title:Text('Nagad'),),
      body: Mbank(provider:'nagad')
    );
  }
}