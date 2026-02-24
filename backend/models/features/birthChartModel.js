const mongoose = require("mongoose");

const birthChartSchema = new mongoose.Schema({
  name: String,
  gender: String,
  birth_date: {
    year: Number,
    month: Number,
    day: Number,
  },
  birth_time: {
    hour: Number,
    minute: Number,
    ampm: String,
  },
  place_of_birth: String,
  astrology_type: String,
  ayanamsa: String,
  chartImage: String, // saved image path
}, { timestamps: true });

module.exports = mongoose.model("BirthChart", birthChartSchema);
