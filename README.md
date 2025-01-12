# Flickit-Assignment

# Backend Setup for Flutter Sports App

This README provides step-by-step instructions to set up and run the backend for the Flutter Sports App project.

---

## Prerequisites

Ensure you have the following installed on your system:

1. **Node.js** (v14.x or higher)
2. **npm** or **yarn** (comes with Node.js)
3. **MongoDB Atlas** account or a local MongoDB instance.
4. **Postman** or a similar API testing tool (optional, for testing endpoints).

---

## Steps to Set Up Backend

### 1. Clone the Repository

```bash
git clone <repository_url>
cd <repository_directory>
```

### 2. Install Dependencies

Run the following command to install all required dependencies:

```bash
npm install
```

### 3. Configure MongoDB Connection

1. Create a free MongoDB Atlas cluster at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).
2. Replace the `MONGODB_CONNECTION_STRING` in the code with your MongoDB connection string.

   Example connection string:
   ```text
   mongodb+srv://<username>:<password>@cluster0.mongodb.net/sports_app?retryWrites=true&w=majority
   ```
3. Alternatively, use your local MongoDB instance:
   ```text
   mongodb://127.0.0.1:27017/sports_app
   ```

### 4. Populate the Database

Run the following script to populate the database with sample data:

#### Dummy Data for Users Collection

```javascript
const User = mongoose.model('user', new mongoose.Schema({ username: String, password: String, totalCount: Number }));

User.insertMany([
  { username: 'john_doe', password: 'password123', totalCount: 60 },
  { username: 'jane_smith', password: 'password456', totalCount: 80 },
  { username: 'alex_jones', password: 'password789', totalCount: 45 }
]);
```

#### Dummy Data for Drills Collection

```javascript
const Drill = mongoose.model('drills', new mongoose.Schema({ name: String, total_count: Number, image: String }));

Drill.insertMany([
  { name: 'Toe Taps', total_count: 40, image: 'https://example.com/toe_taps.png' },
  { name: 'Wall Jumps', total_count: 50, image: 'https://example.com/wall_jumps.png' },
  { name: 'Ball Control', total_count: 30, image: 'https://example.com/ball_control.png' }
]);
```

#### Dummy Data for UserDrill Collection

```javascript
const UserDrill = mongoose.model('user_drill', new mongoose.Schema({userId: String,
    drillId: String,
    drill_name: String,
    count: Number,
    drill_total: Number }));

```

### 5. Start the Server

Run the following command to start the backend server:

```bash
node server.js
```

The server will start running at `http://localhost:3000`.

---

## API Endpoints

### 1. **User Authentication**

**POST** `/api/login`
- Request Body:
  ```json
  {
    "username": "john_doe",
    "password": "password123"
  }
  ```
- Response:
  ```json
  {
    "success": true,
    "userId": "<user_id>"
  }
  ```

### 2. **User Signup**

**POST** `/api/signup`
- Request Body:
  ```json
  {
    "username": "new_user",
    "password": "new_password"
  }
  ```
- Response:
  ```json
  {
    "success": true,
    "userId": "<user_id>"
  }
  ```

### 3. **Fetch Drills**

**GET** `/api/drills`
- Response:
  ```json
  [
    {
      "_id": "<drill_id>",
      "name": "Toe Taps",
      "total_count": 40,
      "image": "https://example.com/toe_taps.png"
    }
  ]
  ```

### 4. **Submit Drill Counts**

**POST** `/api/submit-drill`
- Request Body:
  ```json
  {
    "userId": "<user_id>",
    "drillId": "<drill_id>",
    "drill_name":"<drill_name>",
    "count": <no of drills done by user>,
    "drill_total":<max no. of drills>
  }
  ```
- Response:
  ```json
  {
    "success": true
  }
  ```

### 5. **User Dashboard**

**GET** `/api/user-dashboard/:userId`
- Response:
  ```json
  [
    {
      "drillId": "<drill_id>",
      "count": 30
    }
  ]
  ```

### 6. **Leaderboard**

**GET** `/api/leaderboard`
- Response:
  ```json
  [
    {
      "username": "jane_smith",
      "totalCount": 80
    }
  ]
  ```
