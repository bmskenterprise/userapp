// ignore: file_names
import 'dart:convert';

import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'PackHit.dart';
import 'models/Regular.dart';

class RegularPackFragment extends StatefulWidget {
  const RegularPackFragment({super.key});

  @override
  _RegularPackFragmentState createState() => _RegularPackFragmentState();
}

class _RegularPackFragmentState extends State<RegularPackFragment> {
  // const _RegularPackFragment({super.key});
  late Future<List<RegularPackFragment>> _regularPacksFuture;

  @override
  void initState() {
    super.initState();
    _regularPacksFuture =
        fetchRegularPacks() as Future<List<RegularPackFragment>>;
  }

  Future<List<Regular>> fetchRegularPacks() async {
    try{
    final uri = Uri.parse('${ApiConstants.baseUrl}/api/regular');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Regular.fromJson(json)).toList();
    }} catch(e) {
      throw Exception('Failed to load regularpacks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Regular>>(
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
    );
  }
}
