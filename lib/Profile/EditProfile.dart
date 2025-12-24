import 'package:flutter/material.dart';
import 'package:provider/provider.dart';// as http;
import '../providers/AuthProvider.dart';

/* void main() => runApp(EditProfileApp());

class EditProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfile(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class EditProfile extends StatefulWidget{
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final TextEditingController _controllerUsername = TextEditingController(text: "fajar123@gmail.com",);
  final TextEditingController _controllerName = TextEditingController(text: "Fajar Kun",);
  final TextEditingController _controllerNID = TextEditingController(text: "01 April 2004",);
  //final TextEditingController _controller = TextEditingController(text: "898981239102",);
  //final TextEditingController addressController = TextEditingController();
  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerName.dispose();
    _controllerNID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 16),
                    Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/profile.png',
                            ), // Replace with your image
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: CircleAvatar(
                              backgroundColor: Colors.purple,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Username
                      buildTextField(
                        "Email",
                        Icons.verified_user,
                        _controllerUsername,
                      ),

                      // Name
                      buildTextField("Your Name", Icons.person, _controllerName),

                      // Date of Birth
                      buildTextField(
                        "Date of Birth",
                        Icons.calendar_today,
                        _controllerNID,
                      ),

                      // Phone Number
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text("+62"),
                          ),
                          SizedBox(width: 10),
                          /*Expanded(
                            child: buildTextField(
                              "",
                              Icons.phone,
                              phoneController,
                            ),
                          ),*/
                        ],
                      ),
                      SizedBox(height: 20),

                      // Address
                      /*TextField(
                        controller: addressController,
                        maxLength: 200,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),*/
                      SizedBox(height: 20),

                      // Update Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthProvider>().editProfile();
                        },
                        child: Text("EDIT", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label.isNotEmpty ? label : null,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
