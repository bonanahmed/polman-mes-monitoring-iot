// userModel.js

const mongoose = require("mongoose");

// Define the schema
const monitoringSchema = new mongoose.Schema({
  station: String,
  data: Object,
  updated_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
});

// Create and export the model based on the schema
module.exports = mongoose.model("Monitoring", monitoringSchema);
