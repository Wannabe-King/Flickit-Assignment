const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");

dotenv.config();

mongoose.connect(process.env.MONGODB_CONNECTION_STRING, {
  useNewUrlParser: true,
});

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
  new mongoose.Schema({ userId: String, drillId: String, count: Number })
);

const app = express();
app.use(express.json());

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
  const drill = await Drill.findById(drillId);
  if (count <= drill.total_count) {
    await UserDrill.create({ userId, drillId, count });
    const user = await User.findById(userId);
    user.totalCount += count;
    await user.save();
    res.send({ success: true });
  } else {
    res.send({ success: false });
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
