const mongoose = require("mongoose");

// Define the Patient schema
const patientSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
  },
  dateOfBirth: Date,
  gender: String,
  contactNumber: String,
  email: String,
  address: String,
  bloodGroup: String,
  preferedTiminings: [String],
  activePrescriptions: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Prescription",
    },
  ],
  historicalPrescriptions: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Prescription",
    },
  ],
});
// Create a Patient model from the schema
const Patient = mongoose.model("Patient", patientSchema);

module.exports = Patient;
