import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prescription_software/dialogs/CreatePatientDialog.dart';
import 'package:prescription_software/widgets/PatientSearchCard.dart';

class PatientsWidget extends StatefulWidget {
  final String token;
  const PatientsWidget({super.key, required this.token});
  @override
  _PatientsWidgetState createState() => _PatientsWidgetState();
}

class _PatientsWidgetState extends State<PatientsWidget> {
  List<Map<String, dynamic>> patientData = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch patient data when the widget is initialized
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    final serverUrl = dotenv.env['SERVER_URL'];

    try {
      final response = await http.get(
        Uri.parse(
            '$serverUrl/patients/'), // Replace with your backend API endpoint
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<Map<String, dynamic>> fetchedPatientData = jsonData
            .map((jsonItem) => {
                  "id": jsonItem["_id"],
                  'name': jsonItem['fullName'],
                  'phoneNumber': jsonItem['contactNumber'],
                })
            .toList();

        setState(() {
          patientData = fetchedPatientData;
        });
      } else {
        print(
            'Failed to fetch patient data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching patient data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value.toLowerCase();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Search Patients',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: patientData.length,
                              itemBuilder: (context, index) {
                                final patient = patientData[index];
                                final name = patient['name']!.toLowerCase();
                                final phoneNumber =
                                    patient['phoneNumber']!.toLowerCase();

                                if (name.contains(searchQuery) ||
                                    phoneNumber.contains(searchQuery)) {
                                  return PatientSearchCard(
                                    token: widget.token,
                                    patientid: patient['id'],
                                    patientName: patient['name']!,
                                    patientPhoneNumber: patient['phoneNumber']!,
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CreatePatientDialog();
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
