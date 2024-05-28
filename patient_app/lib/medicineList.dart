import 'package:flutter/material.dart';

class medicineList extends StatefulWidget {
  const medicineList({Key? key}) : super(key: key);

  @override
  State<medicineList> createState() => _medicineListState();
}

class _medicineListState extends State<medicineList> {
  final TextEditingController medicine_name = TextEditingController();
  final TextEditingController _availablestock = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  bool changesMade = false;
  bool isActivated = false;
  String medication_name = '',
      availablecount = '',
      count = '',
      item = 'Tablet',
      instruct = 'Take before meal';
  void toggleReminder() {
    setState(() {
      isActivated = !isActivated;
    });
  }

  List<String> items = [
    'Tablet',
    'Syrup',
    'Capsule',
    'Powder',
    'Drops',
    'Inhaler',
    'Spray',
    'Ointment',
    'Others',
  ];
  List<String> instructions = [
    'Take before meal',
    'Take after meal',
    'Take during meal',
    'Take it on an empty stomach!'
  ];
  void handleSave() {
    // Add your save logic here
    changesMade = false; // Reset changesMade after saving
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved!'),
      ),
    );
  }

  Future<bool> _showDiscardConfirmationDialog() async {
    bool discard = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discard Changes?'),
          content: Text('Do you want to discard the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                discard = true;
                Navigator.of(context).pop(true); // Discard changes
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                handleSave(); // Save changes and continue
                Navigator.of(context).pop(true);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    return discard;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (changesMade) {
          // Show confirmation dialog when attempting to leave without saving
          return await _showDiscardConfirmationDialog();
        }
        return true; // Allow leaving the page without changes
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'New Medication',
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                print('save called');
              },
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // One-third of the screen width
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.4), // Decreased opacity
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                      ),
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: medicine_name,
                                        validator: (value) => value!.isEmpty
                                            ? 'Please Medicine name'
                                            : null,
                                        onSaved: (value) =>
                                            medication_name = value!,
                                        style: const TextStyle(
                                          color: Colors
                                              .black, // Text color set to black
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'Medicine Name',

                                          prefixIcon:
                                              Icon(Icons.medical_services),
                                          border:
                                              OutlineInputBorder(), // Rounded border
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Medicine type',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .orangeAccent, // Text color set to black
                                        ),
                                      ),
                                      DropdownButton<String>(
                                        value: item,
                                        onChanged: (newValue) {
                                          setState(() {
                                            item = newValue!;
                                          });
                                        },
                                        items: items
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
                                            color: Colors.black, fontSize: 16),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.green,
                                          size: 32,
                                        ),
                                        elevation: 4,
                                        underline: Container(
                                          height: 2,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Instruction',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .orangeAccent, // Text color set to black
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      DropdownButton<String>(
                                        value: instruct,
                                        onChanged: (newValue) {
                                          setState(() {
                                            instruct = newValue!;
                                          });
                                        },
                                        items: instructions
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
                                            color: Colors.black, fontSize: 16),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.green,
                                          size: 32,
                                        ),
                                        elevation: 4,
                                        underline: Container(
                                          height: 2,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //TODO refill and schedule
                              Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Refill',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .orangeAccent, // Text color set to black
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        controller: _availablestock,
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value!.isEmpty
                                            ? 'Enter Available Quantity'
                                            : null,
                                        onSaved: (value) =>
                                            availablecount = value!,
                                        style: const TextStyle(
                                          color: Colors
                                              .black, // Text color set to black
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: 'Quantity available',

                                          prefixIcon: Icon(Icons.queue),
                                          border:
                                              OutlineInputBorder(), // Rounded border
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            isActivated
                                                ? 'Reminder Set for Refill'
                                                : 'Set Reminder for refill',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: isActivated
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isActivated
                                                  ? Icons.toggle_on
                                                  : Icons.toggle_off,
                                              size: 26.0,
                                              color: isActivated
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            onPressed: toggleReminder,
                                          ),
                                        ],
                                      ),
                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    medicine_name.dispose();
    _availablestock.dispose();
    _stock.dispose();
    super.dispose();
  }
}
