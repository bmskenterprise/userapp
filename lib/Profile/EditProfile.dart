import 'package:bmsk_userapp/util/baseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* void main() => runApp(EditProfileApp());

class EditProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class EditProfileScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController(text: "fajar123@gmail.com",);
  final TextEditingController nameController = TextEditingController(text: "Fajar Kun",);
  final TextEditingController NIDController = TextEditingController(text: "01 April 2004",);
  final TextEditingController phoneController = TextEditingController(text: "898981239102",);
  final TextEditingController addressController = TextEditingController();
  void updateProfile() {
    // Update profile logic here
    try {
      final uri ='${ApiConstants.baseUrl}/api/update-profile';
      final response = http.post(Uri.parse(uri), body: {});
      if (response.statusCode == 200) {
        v
      }
    } catch (e) {
      // Handle error
    }
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
                        usernameController,
                      ),

                      // Name
                      buildTextField("Your Name", Icons.person, nameController),

                      // Date of Birth
                      buildTextField(
                        "Date of Birth",
                        Icons.calendar_today,
                        NIDController,
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
                          Expanded(
                            child: buildTextField(
                              "",
                              Icons.phone,
                              phoneController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Address
                      TextField(
                        controller: addressController,
                        maxLength: 200,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
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
                          updateProfile();
                        },
                        child: Text("Update", style: TextStyle(fontSize: 16)),
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
