// userModel.js

const mongoose = require("mongoose");

// Define the schema
const bottleCountingSchema = new mongoose.Schema({
  color: {
    type: String,
    required: true,
  },
  uid: {
    type: String,
    required: false,
  },
  status: {
    type: String,
    required: false,
  },
  created_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
  updated_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
});

// Create and export the model based on the schema
module.exports = mongoose.model("BottleCounting", bottleCountingSchema);
