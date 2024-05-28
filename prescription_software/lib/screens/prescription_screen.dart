import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:prescription_software/screens/home_screen.dart';

class PrescriptionGeneratorScreen extends StatefulWidget {
  final String token;
  final String patientId;

  const PrescriptionGeneratorScreen({
    super.key,
    required this.patientId,
    required this.token,
  });

  @override
  _PrescriptionGeneratorScreenState createState() =>
      _PrescriptionGeneratorScreenState();
}

class _PrescriptionGeneratorScreenState
    extends State<PrescriptionGeneratorScreen> {
  late Map<String, dynamic> jwtDecodedToken;
  TextEditingController temperatureController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController medicationNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController beforeAfterFoodController = TextEditingController();
  TextEditingController refillController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  Map<String, dynamic> patientData = {};
  late DateTime selectedDOB;
  String age = '';
  final String currentDate =
      DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  List<Medication> medications = [];
  bool isLoading = true; // Added loading indicator flag

  @override
  void initState() {
    super.initState();
    jwtDecodedToken = JwtDecoder.decode(widget.token);
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    final serverUrl = dotenv.env['SERVER_URL'];

    try {
      final response = await http.get(
        Uri.parse('$serverUrl/patients/${widget.patientId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> patientData = json.decode(response.body);

        setState(() {
          this.patientData = patientData;
          selectedDOB = DateTime.parse(patientData['dateOfBirth']);
          isLoading = false; // Data loaded, set isLoading to false
        });

        calculateAge();
      } else {
        print(
            'Failed to fetch patient details. Status code: ${response.statusCode}');
        // Handle the error if the API request fails
        isLoading = false; // Set isLoading to false on error
      }
    } catch (error) {
      print('Error fetching patient details: $error');
      isLoading = false; // Set isLoading to false on error
    }
  }

  void calculateAge() {
    final now = DateTime.now();
    final difference = now.difference(selectedDOB);
    final ageYears = difference.inDays ~/ 365;
    setState(() {
      age = ageYears.toString();
    });
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Data is not yet available, show a loading indicator.
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Data is available, render the main screen.
      return Scaffold(
        appBar: AppBar(
          title: Text('Prescription Generator'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(token: widget.token),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildSectionHeader('Hospital Information'),
                _buildCard(
                  <Widget>[
                    _buildReadOnlyField(
                        'Hospital Name', jwtDecodedToken['organization']),
                    _buildReadOnlyField(
                        'Doctor Name', jwtDecodedToken['fullName']),
                    _buildReadOnlyField(
                        'License Number', jwtDecodedToken['licenseNumber']),
                  ],
                ),
                _buildSectionHeader('Patient Information'),
                _buildCard(
                  <Widget>[
                    _buildReadOnlyField(
                        'Patient Name', patientData['fullName']),
                    _buildReadOnlyField('Gender', patientData['gender']),
                    _buildReadOnlyField(
                        'DOB', DateFormat('yyyy-MM-dd').format(selectedDOB)),
                    _buildReadOnlyField('Age', age),
                    _buildReadOnlyField(
                        'Mobile Number', patientData['contactNumber']),
                  ],
                ),
                _buildSectionHeader('Vital Signs and Diagnosis'),
                _buildCard(
                  <Widget>[
                    _buildTextInputField(
                        'Temperature (°F)', temperatureController),
                    SizedBox(height: 16.0),
                    _buildTextInputField(
                        'Blood Pressure (mmHg)', bloodPressureController),
                    SizedBox(height: 16.0),
                    _buildTextInputField('Diagnosis', diagnosisController),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildSectionHeader('Medications'),
                Column(
                  children: [
                    _buildTextInputField('Duration', durationController),
                    Center(
                      child: DataTable(
                        columnSpacing: 35,
                        columns: const [
                          DataColumn(label: Text('Medication Name')),
                          DataColumn(label: Text('Dose')),
                          DataColumn(label: Text('Frequency')),
                          DataColumn(label: Text('Duration')),
                          DataColumn(label: Text('Before/After Food')),

                          DataColumn(
                              label: Text(
                                  'Route of Administration')), // New column
                          DataColumn(label: Text('Type of Medicine')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Refill')), // New column
                          DataColumn(label: Text('Action')),
                        ],
                        rows: medications.map((medication) {
                          return DataRow(cells: [
                            DataCell(
                              TextFormField(
                                onChanged: (value) {
                                  medication.medicationName = value;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter name',
                                ),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                onChanged: (value) {
                                  medication.dosage = value;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter dosage',
                                ),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                onChanged: (value) {
                                  medication.frequency = value;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter frequency (1-1-1)',
                                ),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                onChanged: (value) {
                                  medication.duration = value;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter duration',
                                ),
                              ),
                            ),
                            DataCell(
                              DropdownButtonFormField(
                                value: medication.beforeAfterFood,
                                onChanged: (value) {
                                  setState(() {
                                    medication.beforeAfterFood =
                                        value.toString();
                                  });
                                },
                                items: ['Before Food', 'After Food']
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                              ),
                            ),
                            DataCell(
                              DropdownButtonFormField(
                                value: medication.routeOfAdministration,
                                onChanged: (value) {
                                  setState(() {
                                    medication.routeOfAdministration =
                                        value.toString();
                                  });
                                },
                                items: [
                                  'Oral',
                                  'Intravenous',
                                  'Intramuscular',
                                  'Topical',
                                  'Other'
                                ]
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                              ),
                            ),
                            DataCell(
                              DropdownButtonFormField(
                                value: medication.typeOfMedicine,
                                onChanged: (value) {
                                  setState(() {
                                    medication.typeOfMedicine =
                                        value.toString();
                                  });
                                },
                                items: [
                                  'Tablets',
                                  'Capsules',
                                  'Syrups',
                                  'Ointments',
                                  'Other'
                                ]
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                onChanged: (value) {
                                  medication.quantity = int.parse(value);
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Quantity',
                                ),
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                onChanged: (value) {
                                  medication.refill = int.parse(value);
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Refills',
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    medications.remove(medication);
                                  });
                                },
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    addMedication();
                  },
                  child: Text('Add Medication'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    generatePrescription();
                  },
                  child: Text('Generate Prescription'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String text) {
    return Text(
      '$label: $text',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  void addMedication() {
    setState(() {
      medications.add(Medication());
    });
  }

  void generatePrescription() async {
    // Prepare the prescription data
    Map<String, dynamic> prescriptionData = {
      "duration": durationController.text,
      "patientId": widget.patientId,
      "doctorLicenseNumber": jwtDecodedToken['licenseNumber'],
      "organization": jwtDecodedToken['organization'],
      "vitalSigns": {
        "temperature": temperatureController.text,
        "bloodPressure": bloodPressureController.text,
      },
      "diagnosis": diagnosisController.text,
      "medicines": medications.map((medication) {
        return {
          "medicationName": medication.medicationName,
          "dosage": medication.dosage,
          "frequency": medication.frequency,
          "duration": medication.duration,
          "beforeAfterFood": medication.beforeAfterFood,
          "refill": medication.refill,
          "routeOfAdministration": medication.routeOfAdministration,
          "typeOfMedicine": medication.typeOfMedicine,
          "quantity": medication.quantity,
        };
      }).toList(),
    };

    // Send the prescription data to the server
    final serverUrl = dotenv.env['SERVER_URL'];
    final response = await http.post(
      Uri.parse('$serverUrl/doctor/createPrescriptions'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(prescriptionData),
    );

    if (response.statusCode == 201) {
      // Prescription created successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Prescription Created'),
            content: Text('Prescription created successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(token: widget.token)));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Error handling for failed prescription creation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Prescription Creation Failed'),
            content: Text('Failed to create prescription. Please try again.'),
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
  }
}

class Medication {
  String medicationName = '';
  String dosage = '';
  String frequency = '';
  String duration = '';
  String beforeAfterFood = 'Before Food';
  int refill = 0;
  String routeOfAdministration = 'Oral';
  String typeOfMedicine = 'Tablets';
  int quantity = 0;
}
