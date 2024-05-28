import 'package:flutter/material.dart';
import 'package:gehealth_care/SplashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  final String patientId;
  const Register({
    super.key,
    required this.patientId,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<String> preferredTime = [];
  String selectedTiming1 = '7:00 AM';
  String selectedTiming2 = '12:00 PM';
  String selectedTiming3 = '6:00 PM';
  final List<String> timingOptionsMrng = [
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM'
  ];
  final List<String> timingOptionsAfter = [
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM'
  ];
  final List<String> timingOptionsNight = [
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
    '10:00 PM'
  ];

  void _register() async {
    final serverUrl = dotenv.env['SERVER_URL'];
    var register = {"perferedTimings": preferredTime};
    var response = await http.put(
      Uri.parse(
          '$serverUrl/patients/update/preferedTimings/${widget.patientId}'),
      headers: {"Content-Type": "application/json"}, //application/json
      body: jsonEncode(register),
    );
    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (content) => splashScreen(
              patientId: widget.patientId, preferredTime: preferredTime),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height: 100.0), // Adjust the spacing as needed
                    const Text(
                      'Update Preferences',
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Preferred time to eat',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black, // Text color set to black
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          const Text(
                                            'Breakfast',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Text color set to black
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          DropdownButton<String>(
                                            value: selectedTiming1,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedTiming1 = newValue!;
                                              });
                                            },
                                            items: timingOptionsMrng
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.green,
                                              size: 32,
                                            ),
                                            elevation: 4,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          const Text(
                                            'Lunch',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Text color set to black
                                            ),
                                          ),
                                          const SizedBox(width: 46),
                                          DropdownButton<String>(
                                            value: selectedTiming2,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedTiming2 = newValue!;
                                              });
                                            },
                                            items: timingOptionsAfter
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.green,
                                              size: 32,
                                            ),
                                            elevation: 4,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          const Text(
                                            'Dinner',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .black, // Text color set to black
                                            ),
                                          ),
                                          const SizedBox(width: 41),
                                          DropdownButton<String>(
                                            value: selectedTiming3,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedTiming3 = newValue!;
                                              });
                                            },
                                            items: timingOptionsNight
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.green,
                                              size: 32,
                                            ),
                                            elevation: 4,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          preferredTime.addAll([
                                            selectedTiming1,
                                            selectedTiming2,
                                            selectedTiming3
                                          ]);
                                          _register();
                                          preferredTime.clear();
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
