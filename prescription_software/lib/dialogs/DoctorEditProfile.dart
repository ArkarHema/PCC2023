import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prescription_software/screens/login_screen.dart';

class DoctorEditProfileDialog extends StatefulWidget {
  final String profile;

  const DoctorEditProfileDialog({required this.profile, Key? key})
      : super(key: key);

  @override
  _DoctorEditProfileDialogState createState() =>
      _DoctorEditProfileDialogState();
}

class _DoctorEditProfileDialogState extends State<DoctorEditProfileDialog> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();

  bool _obscurePassword = true;

  Future<bool> updateDoctorProfile(
    String doctorId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final serverUrl = dotenv.env['SERVER_URL'];
      final url = Uri.parse('$serverUrl/doctor/update/$doctorId');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: "New Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: organizationController,
                decoration: InputDecoration(labelText: 'Organization'),
              ),
              TextFormField(
                controller: licenseNumberController,
                decoration: InputDecoration(labelText: 'License Number'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final updatedFullName = fullNameController.text;
            final updatedEmail = emailController.text;
            final updatedPassword = passwordController.text;
            final updatedOrganization = organizationController.text;
            final updatedLicenseNumber = licenseNumberController.text;

            final success = await updateDoctorProfile(widget.profile, {
              'fullName': updatedFullName,
              'email': updatedEmail,
              'password': updatedPassword,
              'organization': updatedOrganization,
              'licenseNumber': updatedLicenseNumber,
            });

            if (success) {
              Navigator.of(context).pop(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } else {
              // Handle errors, display an error message, etc.
            }
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    );
  }
}
