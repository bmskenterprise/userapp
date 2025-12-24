import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Index.dart';
import 'providers/AuthProvider.dart';
import 'Register/RegisterForm.dart';
import 'providers/RegisterProvider.dart';   

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // appBar: AppBar(title: Text('Login')),
  String errorMessage = '';
  bool _obscureText = true;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterProvider>().fetchLevels();
    });
  }
  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reg = context.watch<RegisterProvider>();
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:Center(
          child:Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  controller: _controllerUsername,
                  validator: (value)=> value!.isEmpty?'Enter Your Username':null
                    /*if(value!.isEmpty) return 'Enter Your Username';
                    return null;
                  }*/
                ),
                TextFormField(
                  controller: _controllerPassword,
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
                  validator: (value){
                    if(value!.isEmpty) return 'Enter Your Password';
                    return null;
                  },
                  obscureText: _obscureText,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(width*0.5, 50),
                  ),
                  onPressed: () async {
                    /*final success=await  */if(_formKey.currentState!.validate()) {auth.login(_controllerUsername.text, _controllerPassword.text,);
                    if(auth.loggedIn) Navigator.push(context, MaterialPageRoute(builder:(context)=>Index()));}
                      /*setState(() {
                        errorMessage = 'login failed';
                      });
                    }*/
                  },
                  child: Text('LOGIN'),
                ),
                SizedBox(height:40),
                if(reg.lowerLevels.isNotEmpty) ...[TextButton(
                  onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>RegisterForm())),
                  child:Text('Register',textAlign:TextAlign.end,style:TextStyle(color:Colors.blue))
                )]
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
        ),))
      ),
    );
  }
}