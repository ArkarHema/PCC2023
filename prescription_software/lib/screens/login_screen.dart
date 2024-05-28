import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prescription_software/screens/home_screen.dart';
import 'package:prescription_software/screens/registration_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences prefs;

  bool _isLoading = false;
  bool _obscurePassword = true; // Track password visibility

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
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
                Image.asset(
                  'assets/logo.png', // Replace with your app's logo
                  width: 80.0,
                  height: 80.0,
                ),
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
                      0.6, // One-third of the screen width
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Colors.black, // Text color set to black
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(), // Rounded border
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(
                              color: Colors.black, // Text color set to black
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
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
                              border:
                                  const OutlineInputBorder(), // Rounded border
                            ),
                            obscureText:
                                _obscurePassword, // Password visibility toggle
                          ),
                          const SizedBox(height: 24.0),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _login();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue, // Button color
                                      onPrimary: Colors.white, // Text color
                                      padding:
                                          const EdgeInsets.all(16.0), // Padding
                                      textStyle: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    child: const Text('Login'),
                                  ),
                                ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                  color: Colors.blue), // Text color
                            ),
                            child:
                                const Text('Don\'t have an account? Register'),
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

  void _login() async {
    final serverUrl = dotenv.env['SERVER_URL'];
    // Check if the email and password fields are empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in both email and password.'),
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
      return; // Return early to avoid making the API request with empty fields
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '$serverUrl/doctor/login'), // Replace with your actual backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Successful login
        var myToken = jsonResponse['token'];
        prefs.setString("token", myToken);
        // Navigate to the home screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(token: myToken)));
      } else if (response.statusCode == 404) {
        // Doctor not found
        _showErrorDialog('Doctor not found');
      } else if (response.statusCode == 401) {
        // Invalid password
        _showErrorDialog('Invalid password');
      } else {
        // Handle other errors
        _showErrorDialog('An error occurred. Please try again later.');
      }
    } catch (error) {
      // Handle network or server errors
      _showErrorDialog(
          'An error occurred. Please check your internet connection.');
    } finally {
      // Hide the loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
