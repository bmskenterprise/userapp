import 'package:flutter/material.dart';
import 'services/AppService.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});
  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  late Future<List> _noticesFuture;

  @override
  void initState() {
    super.initState();
    _noticesFuture = AppService().fetchNotices();
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