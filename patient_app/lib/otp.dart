import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gehealth_care/updateTimePreferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

class OTPScreen extends StatefulWidget {
  final String patientId;
  final String phone_number;
  OTPScreen({
    super.key,
    required this.patientId,
    required this.phone_number,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;

  Future<void> verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    final otp = textEditingController.text;

    try {
      final serverUrl = dotenv.env['SERVER_URL'];
      final body = {
        "otp": otp,
        "phone_number": "+91${widget.phone_number}",
      };
      final response = await http.post(
        Uri.parse('$serverUrl/patients/verify-OTP'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (content) => Register(patientId: widget.patientId),
          ),
        );
        print('OTP Verification Failed');
      }
    } catch (error) {
      // Handle API request errors
      print('Error: $error');
      // Show an error message or take appropriate action
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        autoDisposeControllers: false,
                        controller: textEditingController,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.transparent,
                        ),
                        onChanged: (value) {
                          // Handle OTP input changes
                        },
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                // Handle OTP verification
                                verifyOTP();
                              },
                              child: const Text("Verify OTP"),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
