//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gehealth_care/otp.dart';
import 'package:gehealth_care/updateTimePreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namecon = TextEditingController();
  final TextEditingController _mobilenumbercon = TextEditingController();
  String _name = '', _phone = '';
  bool _isLoading = false;
  void registerUser() async {
    final serverUrl = dotenv.env['SERVER_URL'];
    var register = {
      "name": _namecon.text,
      "phone_number": "+91${_mobilenumbercon.text}"
    };
    print("start");
    var response = await http.post(Uri.parse('$serverUrl/patients/login'),
        headers: {"Content-Type": "application/json"}, //application/json
        body: jsonEncode(register),);
  print(response.body);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => OTPScreen(
          //     patientId: jsonResponse.toString(),
          //     phone_number: _mobilenumbercon.text),
          builder: (content) => Register(
            patientId: jsonResponse.toString(),),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0), // Adjust the spacing as needed
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Text color set to black
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // One-third of the screen width
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent
                        .withOpacity(0.4), // Decreased opacity
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _namecon,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your name'
                                  : null,
                              onSaved: (value) => _name = value!,
                              style: const TextStyle(
                                color: Colors.black, // Text color set to black
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Name',

                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(), // Rounded border
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _mobilenumbercon,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter phone number'
                                  : null,
                              onSaved: (value) => _phone = value!,
                              style: const TextStyle(
                                color: Colors.black, // Text color set to black
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Phone number',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(), // Rounded border
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _name = _namecon.text;
                                          _phone = _mobilenumbercon.text;
                                          registerUser();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue, // Button color
                                        onPrimary: Colors.white, // Text color
                                        padding: const EdgeInsets.all(
                                            16.0), // Padding
                                        textStyle: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      child: const Text('Login'),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
