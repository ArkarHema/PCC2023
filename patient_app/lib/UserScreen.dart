import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gehealth_care/addMedication.dart';
import 'package:http/http.dart' as http;
import 'package:gehealth_care/widgets/prescription_card.dart';
import 'dart:convert';

class PrescriptionData {
  final String duration;
  final String doctorLicenseNumber;
  final String organization;
  final DateTime prescriptionDate;
  final Map<String, String> vitalSigns;
  final String diagnosis;
  final List<Map<String, dynamic>> medications;

  PrescriptionData(
      {required this.duration,
      required this.doctorLicenseNumber,
      required this.organization,
      required this.prescriptionDate,
      required this.vitalSigns,
      required this.diagnosis,
      required this.medications});
}

// Function to fetch prescription data from the API
Future<List<PrescriptionData>> fetchPrescriptions(String patientId) async {
  try {
    final serverUrl = dotenv.env['SERVER_URL'];
    final response = await http
        .get(Uri.parse('$serverUrl/patients/prescriptions/$patientId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<PrescriptionData> prescriptions = data.map((item) {
        // Map 'medicines' list to the expected type
        final List<Map<String, dynamic>> medicines =
            item['medicines'].map<Map<String, dynamic>>((med) {
          // Map medication fields as needed
          return {
            'name': med['medicationName'],
            'dosage': med['dosage'],
            // Add other medication fields as needed
          };
        }).toList();

        return PrescriptionData(
          duration: item['duration'],
          doctorLicenseNumber: item['doctorLicenseNumber'],
          organization: item['organization'],
          prescriptionDate: DateTime.parse(item['prescriptionDate']),
          vitalSigns: {
            'temperature': item['vitalSigns']['temperature'],
            'bloodPressure': item['vitalSigns']['bloodPressure'],
          },
          diagnosis: item['diagnosis'],
          medications: medicines, // Set medications field with mapped list
        );
      }).toList();
      print(prescriptions);
      return prescriptions;
    } else {
      throw Exception('Failed to fetch prescription data');
    }
  } catch (error) {
    rethrow;
  }
}

class UserScreen extends StatefulWidget {
  final String patientId;
  final List<String> preferredTime;
  const UserScreen(
      {Key? key, required this.patientId, required this.preferredTime});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<PrescriptionData> prescriptions = [];

  @override
  void initState() {
    super.initState();
    fetchPrescriptions(widget.patientId).then((prescriptionList) {
      setState(() {
        prescriptions = prescriptionList;
      });
    }).catchError((error) {
      // Handle error
      print('Error in fetching prescriptions: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Selection'),
      ),
      body: Stack(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Active Prescriptions",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    for (final prescription in prescriptions)
                      PrescriptionCard(
                        prescriptionData: prescription,
                      ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrescriptionGeneratorScreen(
                                patientId: widget.patientId,
                                preferredTime: widget.preferredTime),
                          ),
                        );
                      },
                      child: const Text('+ ADD'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
