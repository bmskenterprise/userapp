import 'package:bmsk_userapp/services/ClientService.dart';
import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});
  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  late Future<List> _noticesFuture;

  @override
  void initState() {
    super.initState();
    _noticesFuture = ClientService().fetchNotices();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
      ),
      body:  Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List>(
        future: _noticesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notices found'));
          } else {
            return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index){
            final notice = snapshot.data![index];
            return Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(
                minHeight: 100, // minimum height
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Text(notice.date),
                  Text(notice.description),
                ],
              ),
            );
          },
        );
        }})
      ),
    );
  }
}