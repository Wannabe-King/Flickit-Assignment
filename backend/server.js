const express = require("express");
const mongoose = require("mongoose");
var cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

mongoose.connect(process.env.MONGODB_CONNECTION_STRING);

const User = mongoose.model(
  "user",
  new mongoose.Schema({
    username: String,
    password: String,
    totalCount: Number,
  })
);
const Drill = mongoose.model(
  "drills",
  new mongoose.Schema({ name: String, total_count: Number, image: String })
);
const UserDrill = mongoose.model(
  "user_drill",
  new mongoose.Schema({
    userId: String,
    drillId: String,
    drill_name: String,
    count: Number,
    drill_total: Number,
  })
);

const app = express();
app.use(express.json());
app.use(cors());

// Signup API
app.post("/api/signup", async (req, res) => {
  const { username, password } = req.body;
  const existingUser = await User.findOne({ username });
  if (existingUser)
    return res.send({ success: false, message: "User already exists" });
  const user = new User({ username, password, totalCount: 0 });
  await user.save();
  res.send({ success: true, userId: user._id });
});

// Login API
app.post("/api/login", async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username, password });
  if (user) return res.send({ success: true, userId: user._id });
  res.send({ success: false });
});

// Fetch Drills
app.get("/api/drills", async (req, res) => {
  const drills = await Drill.find();
  res.send(drills);
});

// Submit Drill Count
app.post("/api/submit-drill", async (req, res) => {
  const { userId, drillId, count } = req.body;
  try {
    const drill = await Drill.findById(drillId);
    if (!drill) {
      return res
        .status(404)
        .send({ success: false, message: "Drill not found" });
    }
    const drill_name = drill.name;
    const drill_total = drill.total_count;

    const userDrill = await UserDrill.findOne({ userId, drillId });
    if (!userDrill) {
      // If the drill is not yet registered for the user
      if (count <= drill.total_count) {
        await UserDrill.create({
          userId,
          drillId,
          drill_name,
          count,
          drill_total,
        });
        const user = await User.findById(userId);
        user.totalCount += count;
        await user.save();
        return res.send({ success: true });
      } else {
        return res.send({
          success: false,
          message: "Count exceeds the drill's total count",
        });
      }
    } else {
      // If the drill is already registered for the user
      const totalRegisteredCount = userDrill.count + count;
      if (totalRegisteredCount <= drill.total_count) {
        userDrill.count = totalRegisteredCount;
        await userDrill.save();
        const user = await User.findById(userId);
        user.totalCount += count;
        await user.save();
        return res.send({ success: true });
      } else {
        return res.send({
          success: false,
          message: "Total count exceeds the drill's total count",
        });
      }
    }
  } catch (error) {
    console.error(error);
    res.status(500).send({ success: false, message: "Internal server error" });
  }
});

// Fetch User Dashboard
app.get("/api/user-dashboard/:userId", async (req, res) => {
  const drills = await UserDrill.find({ userId: req.params.userId });
  res.send(drills);
});

// Leaderboard
app.get("/api/leaderboard", async (req, res) => {
  const users = await User.find().sort({ totalCount: -1 });
  res.send(users);
});

app.listen(process.env.PORT, () => console.log("Server running on port 3000"));
