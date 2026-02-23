# FlightBuddy App - Complete Setup Guide

## 📱 FLUTTER FRONTEND - WHAT I FIXED

### ✅ Issues Resolved:
1. **Removed Duplicate Icons** - You had duplicate bottom navigation bars defined in 3 different files
2. **Consolidated Entry Point** - All navigation now goes through a single `main.dart` file
3. **Fixed Duplicate Screen Definitions** - Removed redundant AlertsScreen, MessagesScreen, ProfileScreen from multiple locations

### 📁 Current Frontend Structure:
```
lib/
├── main.dart (SINGLE ENTRY POINT)
├── features/
│   ├── home/
│   │   └── presentation/
│   │       └── dashboard_screen.dart (Home tab - Flight search + bookings)
│   ├── search/
│   │   └── search_screen.dart (Search tab - Advanced flight search)
│   ├── flights/
│   │   └── search_results_screen.dart (Flight results with booking)
│   ├── alerts/
│   │   └── alerts_screen.dart (Price drops, deals, reminders)
│   ├── messages/
│   │   └── message_screen.dart (Booking confirmations, notifications)
│   └── profile/
│       └── profile_screen.dart (User profile & bookings history)
```

### 🎯 Frontend Screens:

| Tab | File | Function |
|-----|------|----------|
| **Home** | dashboard_screen.dart | Shows greeting, recent bookings, hot offers, flight search form |
| **Search** | search_screen.dart | One-way/Round/Multi-city flight search with advanced filters |
| **Alerts** | alerts_screen.dart | Price drops, deals, check-in reminders, loyalty rewards |
| **Messages** | message_screen.dart | Booking confirmations, payment alerts, flight status |
| **Profile** | profile_screen.dart | User info, booking history, loyalty points, preferences |

---

## 🔧 BACKEND SETUP (Node.js/Express/MongoDB)

Based on your backend structure, here's what to do:

### 1️⃣ **Initial Setup**

```bash
cd flightbuddy-backend
npm install
```

### 2️⃣ **Environment Configuration**

Create a `.env` file in the backend root:

```env
# Database
LOCAL_DATABASE_URI=mongodb://localhost:27017/flightbuddy
MONGO_USER=your_username
MONGO_PASSWORD=your_password

# Server
PORT=3000
NODE_ENV=development

# JWT (for authentication)
JWT_SECRET=your_secret_key_here

# API
BASE_URL=http://localhost:3000

# Email (for booking confirmations)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# Payment Gateway (if using)
STRIPE_SECRET_KEY=your_stripe_key
```

### 3️⃣ **Database Setup**

Connect MongoDB:

```bash
# Option 1: Local MongoDB
mongod

# Option 2: MongoDB Atlas (Cloud)
# Update LOCAL_DATABASE_URI in .env with your Atlas connection string
```

### 4️⃣ **Create Required Database Collections**

Run these in MongoDB:

```javascript
// Users Collection
db.createCollection("users")
db.users.createIndex({ email: 1 }, { unique: true })

// Flights Collection
db.createCollection("flights")
db.flights.createIndex({ from: 1, to: 1, departureDate: 1 })

// Bookings Collection
db.createCollection("bookings")
db.bookings.createIndex({ userId: 1, createdAt: -1 })

// Offers Collection
db.createCollection("offers")

// Alerts Collection
db.createCollection("alerts")
```

### 5️⃣ **Start the Backend Server**

```bash
npm start
# Or for development with auto-reload
npm run dev
```

Expected output:
```
[nodemon] starting `node server.js`
MongoDB connected to : 127.0.0.1:27017
Server running in development mode on port 3000
```

---

## 🔌 API Endpoints Your Flutter App Needs

Create these API routes in your backend:

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout

### Flights
- `GET /api/flights/search` - Search flights
  - Query params: `from`, `to`, `departureDate`, `returnDate`, `passengers`, `class`
- `GET /api/flights/:id` - Get flight details
- `GET /api/flights/trending` - Get trending flights

### Bookings
- `POST /api/bookings/create` - Create booking
- `GET /api/bookings/my-bookings` - Get user's bookings
- `GET /api/bookings/:id` - Get booking details
- `PUT /api/bookings/:id/cancel` - Cancel booking

### Offers
- `GET /api/offers` - Get all active offers
- `POST /api/offers/redeem` - Redeem offer code

### Alerts
- `GET /api/alerts` - Get user's alerts
- `POST /api/alerts/subscribe` - Subscribe to price alerts
- `DELETE /api/alerts/:id` - Delete alert

### User Profile
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users/loyalty-points` - Get loyalty points balance

---

## 📡 Connect Flutter App to Backend

Update the API base URL in your Flutter app:

Create `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // Change this based on your environment
  static const String baseUrl = 'http://YOUR_BACKEND_IP:3000/api';
  
  // Endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String searchFlightsEndpoint = '$baseUrl/flights/search';
  static const String bookFlightEndpoint = '$baseUrl/bookings/create';
  static const String getBookingsEndpoint = '$baseUrl/bookings/my-bookings';
}
```

---

## 🚀 Full Startup Procedure

### **Terminal 1 - Backend:**
```bash
cd flightbuddy-backend
npm start
# Wait for: "Server running in development mode on port 3000"
```

### **Terminal 2 - Flutter (Emulator/Device):**
```bash
cd flightbuddy-1
flutter pub get
flutter run
```

---

## ✨ Frontend Features Now Available:

✅ **Home Tab**
- Quick flight search
- Recent bookings display
- Hot offers carousel
- One-way, Round trip, Multi-city options

✅ **Search Tab** 
- Advanced search filters
- Swap cities button
- Date pickers for departure/return
- Passenger selector
- Travel class selection

✅ **Alerts Tab**
- Price drop notifications
- Check-in reminders
- Last minute deals
- Referral bonuses

✅ **Messages Tab**
- Booking confirmations
- Payment alerts
- System notifications
- Flight status updates

✅ **Profile Tab**
- User information
- Booking history with statistics
- Loyalty points balance
- Payment methods management
- Preference settings

---

## 🐛 Common Issues & Solutions

### Issue: "Connection refused" error
**Solution:** Make sure backend is running on correct IP/port
```bash
# For local testing
http://localhost:3000

# For emulator testing  
http://10.0.2.2:3000

# For real device
http://YOUR_PC_IP:3000
```

### Issue: MongoDB connection error
**Solution:** Start MongoDB first
```bash
# On Windows
mongod

# On Mac
brew services start mongodb-community

# On Linux
sudo service mongod start
```

### Issue: CORS errors
**Solution:** Add to your Express backend:
```javascript
npm install cors
const cors = require('cors');
app.use(cors());
```

---

## 📝 Your Backend TODO List

- [ ] Setup `.env` file with MongoDB connection
- [ ] Start MongoDB service
- [ ] Run `npm install` to install dependencies
- [ ] Run `npm start` to start server
- [ ] Create API endpoints listed above
- [ ] Test API endpoints using Postman
- [ ] Connect Flutter app to backend (update API URLs)
- [ ] Add JWT authentication
- [ ] Setup email notifications for bookings
- [ ] Implement payment gateway integration

---

**Ready to build your FlightBuddy app? 🎉**
