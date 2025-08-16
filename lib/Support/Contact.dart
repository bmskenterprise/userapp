import 'dart:convert';
import 'package:bmsk_userapp/Toast.dart';
import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


//void main() => runApp(ContactApp());
class ContactScreen extends StatefulWidget {
       ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late List contacts;bool loading=true;
  late List<ContactOption> options;
  
  @override
  void initState() {
    fetchContacts();
    super.initState();
  }
  
  Future fetchContacts () async{
    try {
      final response = await http.get(Uri.parse(ApiConstants.contact));
      if(response.statusCode==200){
        setState(() {
          final data=jsonDecode(response.body);
          contacts=data['contacts'];
          options = [
    ContactOption(
      name: 'WhatsApp',
      logo: 'WhatsApp_Logo_green.svg',
      color: Color(0xFF25D366),
      contactURL: 'https://wa.me/${contacts['wa']}'
    ),
    ContactOption(
      name: 'Telegram',
      logo: 'Telegram_2019_Logo.svg',
      color: Color(0xFF0088cc),
      contactURL: 'https://t.me/${contacts['telegram']}'
    ),
    ContactOption(
      name: 'Messenger',
      logo: 'Facebook_Messenger_logo_2025.svg',
      color: Color(0xFFE1306C),
      contactURL:'https://m.me/${contacts['messenger']}'
    ),
    ContactOption(
      name: 'Call',
      logo: 'telephone_call_logo.png',
      color: Colors.black87,
      contactURL: 'tel:${contacts['call']}'
    ),
  ];loading=false;
        });
      }
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: loading?Center(child:CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: options.map((option) => ContactTile(option: option)).toList(),
        ),
      ),
    );
  }
}

class ContactOption {
  final String name;
  final String logo;
  final Color color;
  final String contactURL;

  ContactOption({required this.name, required this.logo, required this.color,required this.contactURL});
}

class ContactTile extends StatelessWidget {
  final ContactOption option;

  ContactTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(option.contactURL);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          Toast({'message':'Could not launch $url', 'success': false});
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              // ignore: deprecated_member_use
              backgroundColor: option.color.withOpacity(0.1),
              child: Image.asset(option.logo),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                option.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
