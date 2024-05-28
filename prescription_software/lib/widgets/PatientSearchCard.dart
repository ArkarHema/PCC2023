import 'package:flutter/material.dart';
import 'package:prescription_software/dialogs/UpdatePatientDialog.dart';
import 'package:prescription_software/screens/prescription_screen.dart';

class PatientSearchCard extends StatelessWidget {
  final String patientName;
  final String patientPhoneNumber;
  final String patientid;
  final String token;

  const PatientSearchCard({
    required this.token,
    required this.patientid,
    required this.patientName,
    required this.patientPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0, // Increased elevation for a raised appearance
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.all(16.0), // Padding around the ListTile content
        leading: Icon(
          Icons.person,
          size: 50.0, // Increase icon size
          color: Colors.grey, // Change icon color
        ),
        title: Text(
          patientName,
          style: TextStyle(
            fontSize: 18.0, // Increase font size
            fontWeight: FontWeight.bold, // Make text bold
          ),
        ),
        subtitle: Text(
          patientPhoneNumber,
          style: TextStyle(
            fontSize: 16.0, // Increase font size
            color: Colors.grey, // Change text color
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescriptionGeneratorScreen(
                            patientId: patientid, token: token)));
              },
              child: Text("Add Prescription"),
            ),
            SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UpdatePatientDialog(patientId: patientid);
                  },
                );
              },
              child: Text("Update Details"),
            ),
          ],
        ),
      ),
    );
  }
}
