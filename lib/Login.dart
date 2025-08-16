import 'package:bmsk_userapp/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final width = MediaQuery.of(context).size.width;
    
    return  Scaffold(
      // appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Email')),
            TextField(
              controller: passwordController, 
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: _obscureText?Icon(Icons.visibility):Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                    //});
                  }
                )
              ), 
              obscureText: _obscureText,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(width*0.5, 50),
              ),
              onPressed: () async {
                /*final success = */await auth.login(usernameController.text, passwordController.text,);
                /*if (!success) {
                  setState(() {
                    errorMessage = 'login failed';
                  });
                }*/
              },
              child: Text('login'),
            ),
              /*onPressed: () async {
                final success = await auth.login(usernameController.text, passwordController.text,);
                if (!success) {
                  setState(() {
                    errorMessage = 'Login failed';
                  });
                }
              },
              child: Text('Login'),
            ),
            if (errorMessage.isNotEmpty) Text(errorMessage, style: TextStyle(color: Colors.red)),*/
          ],
        ),
      ),
    );
  }
}