import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UpdatePatientDialog extends StatefulWidget {
  final String patientId;

  UpdatePatientDialog({required this.patientId});

  @override
  _UpdatePatientDialogState createState() => _UpdatePatientDialogState();
}

class _UpdatePatientDialogState extends State<UpdatePatientDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  String selectedGender = "Male";
  String selectedBloodGroup = "A+";
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final List<String> genderOptions = ["Male", "Female", "Other"];
  final List<String> bloodGroupOptions = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];

  @override
  void initState() {
    super.initState();
    // Fetch patient details when the dialog is initialized
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
          fullNameController.text = patientData['fullName'];
          dateOfBirthController.text = patientData['dateOfBirth'];
          selectedGender = patientData['gender'];
          contactNumberController.text = patientData['contactNumber'];
          emailController.text = patientData['email'];
          addressController.text = patientData['address'];
          selectedBloodGroup = patientData['bloodGroup'];
        });
      } else {
        print(
            'Failed to fetch patient details. Status code: ${response.statusCode}');
        // Handle the error if the API request fails
      }
    } catch (error) {
      print('Error fetching patient details: $error');
    }
  }

  Future<void> _updatePatient() async {
    if (_formKey.currentState!.validate()) {
      final fullName = fullNameController.text;
      final dateOfBirth = dateOfBirthController.text;
      final gender = selectedGender;
      final bloodGroup = selectedBloodGroup;
      final contactNumber = '+91${contactNumberController.text}';
      final email = emailController.text;
      final address = addressController.text;

      final serverUrl = dotenv.env['SERVER_URL'];

      final response = await http.put(
        Uri.parse('$serverUrl/patients/update/${widget.patientId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'fullName': fullName,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'contactNumber': contactNumber,
          'email': email,
          'bloodGroup': bloodGroup,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        // Successful update, you can handle the response here
        print('Patient updated successfully');
        Navigator.of(context).pop(); // Close the dialog
      } else {
        // Handle the error if the API request fails
        print('Failed to update patient. Status code: ${response.statusCode}');
        // You can display an error message to the user here
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      dateOfBirthController.text =
          "${picked.month}/${picked.day}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width * 0.5;

    return AlertDialog(
      title: Text(
        'Update Patient',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: dialogWidth,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'John Doe',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateOfBirthController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'MM/DD/YYYY',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField(
                  value: selectedGender,
                  onChanged: (value) => setState(() {
                    selectedGender = value.toString();
                  }),
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField(
                  value: selectedBloodGroup,
                  onChanged: (value) => setState(() {
                    selectedBloodGroup = value.toString();
                  }),
                  items: bloodGroupOptions.map((String bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Blood Group',
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      '+91',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: contactNumberController,
                        decoration: InputDecoration(
                          labelText: 'Contact Number',
                          hintText: '12345-12345',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a contact number';
                          }
                          // You can add additional validation if needed
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@example.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email address';
                    }
                    // You can add email format validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: '123 Main St, City, Country',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _updatePatient,
          child: Text(
            'Update',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
        ),
      ],
    );
  }
}
