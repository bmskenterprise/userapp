//import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/RegisterProvider.dart';
//import '../widgets/Toast.dart';
import '../Index.dart';
import '../providers/AuthProvider.dart';
import 'VerifyMobileNumber.dart';
import 'RegFee.dart';

class RegisterForm extends StatefulWidget {
  //final Function nextHandler;
  const RegisterForm({super.key/*,required this.nextHandler*/});
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}


class _RegisterFormState extends State<RegisterForm> {
//late _selectedLevel/*=''*/;
  //late String _selectedRegFee;              
  //late TextEditingController _controllerName; 
  //late TextEditingController _controllerNIDNumber; 
  final _formKey = GlobalKey<FormState>();
  //bool _obscureText = true;
  Map<String,dynamic> userData={};

  @override
  void initState() {
    //_controllerName=TextEditingController(text:Provider.of<RegisterProvider>(context,listen: false).name);
    //_controllerNIDNumber = TextEditingController(text: Provider.of<RegisterProvider>(context, listen: false).nidNumber);
    super.initState();
     
  }
                
                  
                
                  
                
                  
                
                  
                
                  
                
                  
                
  @override
  Widget build(BuildContext context) {
    final reg=context.watch<RegisterProvider>();
    String selectedLevel = reg.lowerLevels[0]['level'];
    final auth = context.read<AuthProvider>();
         
      
    return Scaffold(
      body: reg.loading?Center(child:CircularProgressIndicator()):reg.lowerLevels.isEmpty?Center(child:Text('server issue')): Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*TextFormField(
                decoration: InputDecoration(
                  label: Text(' username'),
                  prefixIcon: Icon(Icons.person)
                ),
                validator: (value) {
                  if(value==null || value.isEmpty){
                    return 'Enter a valid username';
                  }
                  if (!(RegExp(r'^[a-zA-Z0-9]{4,15}$').hasMatch(value!))) {
                    return 'username only include alpha, number';
                  }
                  return null;
                },
                onSaved: (value) {
                  userData['username'] = value;
                },
              ),*/
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                ),
                value: selectedLevel,
                items:reg.lowerLevels.map<DropdownMenuItem<String>>((Map<String, dynamic> l)=>DropdownMenuItem<String>(value:l['level'].toString(), child:Text(l['level'].toString().toUpperCase()))).toList(),
                onChanged: (String? v) { selectedLevel=v!;context.read<RegisterProvider>().onLevelChange(v);},
              ),
              Text('রেজিস্ট্রেশন ফি \u09F3${reg.currentLevel!['regFee'].toString()}', style:TextStyle(color:Colors.red, fontSize:20)),SizedBox(height:50),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Username'),
                  hintText: '01*********',border:OutlineInputBorder()
                ),
                validator: (value) {
                  if(value==null || value.isEmpty){return 'Enter a Mobile Number';}
                  if (!(RegExp(r'^01[3-9]\d{8}$').hasMatch(value))) {return 'Enter a valid Mobile Number';}
                  return null;
                },
                onSaved: (value) {
                  userData['username'] = value;
                },
              ),SizedBox(height:30),
              TextFormField(
                //controller: TextEditingController(text: Provider.of<RegisterProvider>(context, listen: false).name),
                decoration: InputDecoration(label: Text('Full Name'),border:OutlineInputBorder()),
                validator: (value) {
                  if(value==null || value.isEmpty){return 'Enter your name';}
                  if(value.length<4 || value.length>50){return 'Name must be greater than 3 character and less than 50';}
                  //if (!(RegExp(r'^(?=.*[a-zA-Z]{3,})[a-zA-Z\s]$').hasMatch(value))) {return 'Enter a valid name';}
                  return null;
                },
                onSaved: (value){
                  userData['fullname'] = value;
                },
              ),SizedBox(height:30),
        
              TextFormField(
                //controller: _controllerNIDNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(label: Text('NID Number'),border:OutlineInputBorder()),
                validator: (value) {
                  if(value==null || value.isEmpty){return 'Enter your NID';}
                  if(value.length<4 || value.length>6){return 'Must be greater than 4 character and less than 6';}
                  if (!(RegExp(r'^\d{4,6}$').hasMatch(value))) {}
                  return null;
                },
                onSaved: (value) {userData['nid'] = value;},
                  //userData['nid'] = value;
                
              ),SizedBox(height:30),
        
              TextFormField(
                //obscureText: _obscureText,
                decoration: InputDecoration(
                  label: Text(' Password'),border:OutlineInputBorder()
                  /*suffixIcon: IconButton(
                    icon: _obscureText?Icon(Icons.visibility):Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                      //});
                    }
                  )*/
                ),
                validator: (value) {
                  if(value==null || value.isEmpty){return 'Set a Password';}
                  if(value.length<8 || value.length>32){return 'must be greater than 8 character and less than 32';}
                  if (!(RegExp(r'[!@#$%^&*(),.?":{}|<>a-zA-Z0-9]{8,32}').hasMatch(value))) {return 'Enter a valid password ';}
                  return null;
                },
                onSaved: (value) {
                  userData['password'] = value;
                },
              ),SizedBox(height:30),
        
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(label: Text('PIN Number'),border:OutlineInputBorder()),
                validator: (value) {
                  if(value==null || value.isEmpty){return 'Set a pin';}
                  if(value.length<4 || value.length>6){return 'Must be greater than 4 character and less than 6';}
                  if (!(RegExp(r'^\d{4,6}$').hasMatch(value))) {}
                  return null;
                },
                onSaved: (value) {userData['pin'] = value;},
              ),SizedBox(height:60),
                  
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(MediaQuery.of(context).size.width*0.5,50)
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();context.read<RegisterProvider>().setRegData(userData);
                    if(reg.hasRegFee) {Navigator.push(context,MaterialPageRoute(builder: (context)=>RegFee()));return;}
                    if(reg.hasOTP){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyMobileNumber()));return;
                    }
                    await auth.register(userData);
                    if(auth.loggedIn){Navigator.push(context, MaterialPageRoute(builder:(context)=>Index()));}
                  }
                },
                child: Text((reg.hasOTP||reg.hasRegFee)?'NEXT':'REGISTER'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
  
  /*Future getOTP(String username) async {
    try{
      final uri = Uri.parse(ApiConstants.verifyUser['url']);
      final response = await http.post(uri,headers:{'Content-Type':'application/json'},body: jsonEncode({'username':username}));
      if(response.statusCode == 200) {return jsonDecode(response.body);}
        if (response.statusCode == 400) {
          Toast({'message':ApiConstants.verifyUser['client-err'], 'success':false});
        }
        if (response.statusCode == 500) {
          Toast({'message':ApiConstants.verifyUser['server-err'], 'success':false});
        }
        else {
          throw Exception('Failed to register');
        }
    } catch (e) {
      print('err');
    }
  }*/
  //}
  /*@override
  void dispose() {
    _controllerName.dispose(); // Always dispose controllers to avoid memory leaks
     _controllerNIDNumber.dispose();
    super.dispose();
  }*/
}

                  
                
                  
                
                  
                
                  
                
                  