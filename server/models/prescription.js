const mongoose = require("mongoose");
const Medication = require("./medication");

// Define the Prescription schema
const prescriptionSchema = new mongoose.Schema({
  duration: String, // How long the prescription should be taken
  patientid: String,
  doctorLicenseNumber: String,
  organization: String,
  prescriptionDate: {
    type: Date,
    default: Date.now,
  },
  vitalSigns: {
    temperature: String,
    bloodPressure: String,
  },
  diagnosis: String,
  medicines: [Medication.schema],
  // Add more fields as needed
});

const Prescription = mongoose.model("Prescription", prescriptionSchema);

module.exports = Prescription;
