const mongoose = require("mongoose");
const { watch, socketio } = require("./watch");
const express = require("express");
const app = express();
const http = require("http");
const { Server } = require("socket.io"); // import socket module
const cors = require("cors");
const dotenv = require("dotenv");
const Monitoring = require("./model/Monitoring");
dotenv.config();

// DATABASES
mongoose.connect(
  `${process.env.MONGODB_URI}`,
  { useNewUrlParser: true, useUnifiedTopology: true },
  () => {
    console.log("Database Connection Success");
  }
);
let db = mongoose.connection;

// config socketio
const allowlist = ["http://localhost:3000/", "http://127.0.0.1:3000/"];

const options = {
  cors: {
    origin: allowlist,
  },
};
app.use(cors(options));
const allowCrossDomain = (req, res, next) => {
  res.header("Access-Control-Allow-Origin", "http://localhost:3000"); // allow requests from any other server
  res.header("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"); // allow these verbs
  res.header("Access-Control-Allow-Credentials", true);
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Cache-Control"
  );
  next();
};
app.use(allowCrossDomain);
const server = http.createServer(app);
// init new instance of socketio
const io = new Server(server, {
  transports: ["websocket", "polling"],
  // withCredentials: true,
  allowEIO3: true,
  cors: {
    // credentials: true,
    // origin: "http://localhost:3000",
    origin: "*",
    methods: ["GET", "POST", "OPTIONS"],
  },
});

// handle on connection
io.on("connection", async (socket) => {
  console.log("begin connection", socket.id);
  const data = await Monitoring.findOne({ station: "distribution" });
  io.emit("initData", data);

  // handle on disconnect ** just for testing/development
  socket.on("disconnect", () => {
    console.log("someone leaving");
  });
});

// end of config socket io

db.on("error", console.error.bind(console, "Database Connection Error"));
db.once("open", async () => {
  console.log("Database is connected");
  watch(io); // passing socket instance
});

const PORT = process.env.SERVER_PORT || 5000;
server.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
