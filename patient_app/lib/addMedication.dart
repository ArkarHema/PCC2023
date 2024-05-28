import 'package:flutter/material.dart';
import 'package:gehealth_care/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class PrescriptionGeneratorScreen extends StatefulWidget {
  final String patientId;
  final List<String> preferredTime;

  const PrescriptionGeneratorScreen({
    Key? key,
    required this.patientId,
    required this.preferredTime,
  }) : super(key: key);

  @override
  _PrescriptionGeneratorScreenState createState() =>
      _PrescriptionGeneratorScreenState();
}

class _PrescriptionGeneratorScreenState
    extends State<PrescriptionGeneratorScreen> {
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

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    // Implement fetching patient details from your server here
    // ...
  }

  void calculateAge() {
    // Implement age calculation logic here
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Generator'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Handle closing the screen here
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSectionHeader('Vital Signs and Diagnosis'),
            _buildTextInputField('Temperature', temperatureController),
            const SizedBox(height: 5),
            _buildTextInputField('Blood Pressure', bloodPressureController),
            const SizedBox(height: 5),
            _buildTextInputField('Diagnosis', diagnosisController),
            const SizedBox(height: 5),
            _buildTextInputField('Duration', durationController),
            // Medications Section
            _buildSectionHeader('Medications'),
            Column(
              children: [
                for (final medication in medications)
                  ListTile(
                    title:
                        Text('Medication Name: ${medication.medicationName}'),
                    subtitle: Text('Dosage: ${medication.dosage}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          medications.remove(medication);
                        });
                      },
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showAddMedicationDialog();
                  },
                  child: Text('Add Medication'),
                ),
              ],
            ),

            SizedBox(height: 16.0),

            // Generate Prescription Button
            ElevatedButton(
              onPressed: () {
                generatePrescription();
              },
              child: Text('Generate Prescription'),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildTextInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _showAddMedicationDialog() async {
    final newMedication = Medication();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Medication'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) {
                    newMedication.medicationName = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter name',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    newMedication.dosage = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter dosage',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    newMedication.frequency = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter frequency',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    newMedication.duration = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter duration',
                  ),
                ),
                DropdownButtonFormField(
                  value: newMedication.beforeAfterFood,
                  onChanged: (value) {
                    setState(() {
                      newMedication.beforeAfterFood = value.toString();
                    });
                  },
                  items: ['Before Food', 'After Food']
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                ),
                DropdownButtonFormField(
                  value: newMedication.typeOfMedicine,
                  onChanged: (value) {
                    setState(() {
                      newMedication.typeOfMedicine = value.toString();
                    });
                  },
                  items: ['Tablets', 'Capsules', 'Syrups', 'Ointments', 'Other']
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                ),
                DropdownButtonFormField(
                  value: newMedication.routeOfAdministration,
                  onChanged: (value) {
                    setState(() {
                      newMedication.routeOfAdministration = value.toString();
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
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    newMedication.quantity = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Quantity',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    newMedication.refill = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Refills',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  medications.add(newMedication);
                });
                // NotificationSetter(newMedication.medicationName,
                //     newMedication.frequency, widget.preferredTime);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void generatePrescription() async {
    // Prepare the prescription data
    Map<String, dynamic> prescriptionData = {
      "duration": durationController.text,
      "patientId": widget.patientId,
      "doctorLicenseNumber": "Your ID",
      "organization": "You",
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
                          builder: ((context) => homeScreen(
                              patientId: widget.patientId,
                              preferredTime: widget.preferredTime))));
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
  String routeOfAdministration = 'Oral';
  String typeOfMedicine = 'Tablets';
  int quantity = 0;
  int refill = 0;
}
