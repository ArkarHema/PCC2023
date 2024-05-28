require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const app = express();
const admin = require("firebase-admin");
const serviceAccount = require("./firebaseServiceAccount.json");
const doctorRoutes = require("./routes/doctorRoutes");
const patientRoutes = require("./routes/patientRoutes");
const { handleNotification } = require("./firebase.config");

// Middleware setup
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "gs://hostel-management-app-69094.appspot.com",
  projectId: "hostel-management-app-69094",
});

mongoose.connection.once("open", () => {
  console.log("MongoDB connected successfully!");
});

// Use doctorRoutes with the /doctor prefix
app.use("/doctor", doctorRoutes);
// Use patientRoutes with the /patient prefix
app.use("/patients", patientRoutes);
// Start the server

app.get("/", async (req, res) => {
  await handleNotification(
    "New Medication Prescription Added",
    "Your latest visit to Apollo Hosipital at 02/02/2023",
    "dIfzw_rMT8-ZvcXZ7okvmz:APA91bE_O3CZaW-_mZ8K67XCif43mPLx3_3bA9zut4Vc9P2rrrkSBFKV2_Zjs1A3LR52EKR4lgTshJaG9UWsRdcPRMPRZ1l7rrpZ_plpSNNL4VIF1K_MUL43SGsGrOY57QXd8lbmGhru"
  );
  res.send("done");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
