import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prescription_software/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
        .hasMatch(value)) {
      return 'Password must include at least one uppercase letter, one lowercase letter, one number, and one special character (e.g., @, \$, !, %, *, ?, &).';
    }
    return null;
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
                Icon(
                  Icons.person,
                  size: 80.0,
                  color: Colors.black,
                ),
                SizedBox(height: 12.0),
                Text(
                  'Registration',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Doctor\'s Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            obscureText: !_passwordVisible,
                            validator: _validatePassword,
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password must include:',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '- At least 8 characters',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '- At least one uppercase letter',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '- At least one lowercase letter',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '- At least one number',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '- At least one special character (e.g., @, \$, !, %, *, ?, &)',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _organizationController,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Hospital/Organization',
                                    prefixIcon: Icon(Icons.business),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _licenseNumberController,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'License Number',
                                    prefixIcon: Icon(Icons.assignment_ind),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.0),
                          _isLoading
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _register();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      padding: EdgeInsets.all(16.0),
                                      textStyle: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    child: Text('Register'),
                                  ),
                                ),
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(color: Colors.blue),
                            ),
                            child: Text('Already have an account? Login'),
                          ),
                        ],
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

  void _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _organizationController.text.isEmpty ||
        _licenseNumberController.text.isEmpty) {
      _showAlertDialog('Error', 'Please fill in all fields.');
      return;
    }

    final password = _passwordController.text;
    final passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$',
    );

    if (password.length < 8 || !passwordRegExp.hasMatch(password)) {
      _showAlertDialog(
        'Error',
        'Password must be at least 8 characters and include at least one uppercase letter, one lowercase letter, one number, and one special character (e.g., @, \$, !, %, *, ?, &).',
      );
      return;
    }

    final serverUrl = dotenv.env['SERVER_URL'];

    if (serverUrl == null) {
      _showAlertDialog('Error', 'Server URL is not defined in .env');
      return;
    }

    final registrationData = {
      'fullName': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'organization': _organizationController.text,
      'licenseNumber': _licenseNumberController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/doctor/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(registrationData),
      );

      if (response.statusCode == 201) {
        // Registration successful
        _showAlertDialog('Success', 'Registration successful!');
        Navigator.pushReplacementNamed(context, '/');
        // You can navigate to another screen or perform other actions here
      } else if (response.statusCode == 409) {
        // Registration conflict (e.g., email already exists)
        _showAlertDialog(
            'Error', 'Email already in use. Please use a different email.');
      } else {
        // Registration failed for other reasons
        _showAlertDialog(
            'Error', 'Registration failed. Please try again later.');
      }
    } catch (error) {
      // Handle network or other errors
      print(error);
      _showAlertDialog('Error',
          'An error occurred during registration. Please try again later.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _organizationController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }
}
