import 'package:flutter/material.dart';
import 'Contact.dart';
import 'Feedback.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [Tab(text:'contact'), Tab(text: 'feedback')]
          ),
        ),
        body: TabBarView(
          children:[ContactScreen(), FeedbackScreen()]
        )
      )
    );
  }
}