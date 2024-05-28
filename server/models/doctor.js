const mongoose = require("mongoose");

// Define the Doctor schema
const doctorSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
  },
  licenseNumber: {
    type: String,
    unique: true,
    required: true,
  },
  email: {
    type: String,
    unique: true,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  organization: {
    type: String,
    required: true,
  },
});

// Create a Doctor model from the schema
const Doctor = mongoose.model("Doctor", doctorSchema);

module.exports = Doctor;
