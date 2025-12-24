import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'widgets/Mbank.dart';


class Bkash extends StatefulWidget {
  const Bkash({super.key});
  @override
  State<Bkash> createState() => _BkashState();
}

class _BkashState extends State<Bkash> {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return auth.authPrefs['accesses'].contains['bkash']?Center(child:Text('এই মুহূর্তে Bkash অনুমতি নেই')): Scaffold(
      appBar: AppBar(title:Text('Bkash'),),
      body: Mbank(provider:'bkash')
    );
  }
}