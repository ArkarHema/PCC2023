const mongoose = require("mongoose");

const medicationSchema = new mongoose.Schema({
  medicationName: String,
  dosage: String,
  frequency: String,
  duration: String,
  beforeAfterFood: String,
  refill: Number,
  routeOfAdministration: String,
  typeOfMedicine: String,
  quantity: Number,
  adherence: [
    {
      day: Date, // Date for which adherence records are applicable
      morning: {
        timestamp: Date,
        taken: Boolean,
      },

      afternoon: {
        timestamp: Date,
        taken: Boolean,
      },

      night: {
        timestamp: Date,
        taken: Boolean,
      },
    },
  ],
});

const Medication = mongoose.model("Medication", medicationSchema);

module.exports = Medication;
