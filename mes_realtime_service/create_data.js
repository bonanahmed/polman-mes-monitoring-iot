const mongoose = require("mongoose");
const AbsensiUpdate = require("./model/AbsensiUpdate");
//Connect to DB
mongoose.connect(
  `mongodb+srv://admin:Admin123@cluster0.p9f8u.mongodb.net/akti?retryWrites=true&w=majority`,
  { useNewUrlParser: true, useUnifiedTopology: true },
  () => {
    console.log("Database Connection Success");
  }
);
let db = mongoose.connection;
db.on("error", console.error.bind(console, "Database Connection Error"));
db.once("open", async () => {
  console.log("Database is connected");
  createData();
  // updateData();
});

async function createData() {
  const dateNow = new Date();
  let isoDate = dateNow.toISOString();
  await AbsensiUpdate.create({
    noReg: Date.now(),
    fullName: "Aris Budiarto",
    attendanceStatus: "WFO",
    role: "student",
    activityTime: {
      start: isoDate,
      finish: isoDate,
    },
    firstCheckIn: isoDate,
    firstCheckOut: isoDate,
    lastCheckIn: isoDate,
    lastCheckOut: isoDate,
    healthStatus: {
      shd: "sehat",
      bodyTemp: 36.6,
      peduliLindung: "sehat",
    },
    session: [5],
    kelas: ["iot"],
    checkInPlace: "Main Lobby",
  });
}
async function updateData() {
  await AbsensiUpdate.findByIdAndUpdate("623c615896b85b01fd99c999", {
    fullName: "JSDJASDADS",
  });
}
async function updateDataAll() {
  await AbsensiUpdate.findByIdAndUpdate("623c615896b85b01fd99c999", {
    fullName: "JSDJASDADS",
  });
}
