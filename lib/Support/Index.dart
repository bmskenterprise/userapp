import 'package:flutter/material.dart';
import 'Contact.dart';
import 'Feedback.dart';

class Support extends StatelessWidget {
  const Support({super.key});

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
          children:[Contact(), FeedbackScreen()]
        )
      )
    );
  }
}