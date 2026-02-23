# 🚀 FLIGHTBUDDY - QUICK START GUIDE

## ⚡ Quick Commands

### Run the App (Flutter)
```bash
cd c:\Developer\Flutter\flightbuddy-1
flutter pub get          # Get dependencies
flutter run             # Run on connected device/emulator
```

### Run Backend (Node.js)
```bash
cd flightbuddy-backend
npm install             # Install dependencies (first time only)
npm start              # Start server
# Expected: "Server running on port 3000"
```

### Start MongoDB
```bash
# Windows: Already running as service
# Mac: brew services start mongodb-community
# Linux: sudo service mongod start

# Verify:
mongo --version
```

---

## ✅ PRE-LAUNCH CHECKLIST

- [ ] **Flutter SDK** installed (`flutter --version`)
- [ ] **Device/Emulator** running (`flutter devices`)
- [ ] **Node.js** installed (`node --version`)
- [ ] **MongoDB** running (`mongo --version`)
- [ ] **Dependencies installed** (`flutter pub get`)
- [ ] **Backend `.env` configured**
- [ ] **Port 3000** available for backend
- [ ] **Git** repository initialized (optional)

---

## 📱 WHAT YOU'LL SEE

### Startup Sequence:
1. **Splash Screen** (if configured)
2. **Bottom Navigation Bar** with 5 tabs
3. **Home Tab Active** by default
4. Shows greeting, bookings, and offers

### Tab Navigation:
- **Tap home icon** → Home screen with quick search
- **Tap search icon** → Advanced search form
- **Tap bell icon** → Alerts & deals (8 types)
- **Tap message icon** → Messages & notifications (5 types)
- **Tap profile icon** → User profile & settings

---

## 🐛 TROUBLESHOOTING

### Issue: App crashes on startup
**Solution:**
```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

### Issue: "No devices found"
**Solution:**
```bash
# Start emulator
# On Windows: Open Android Studio > AVD Manager > Run emulator
# Or connect real device with USB debugging enabled

# Then:
flutter devices
flutter run
```

### Issue: "Port 3000 already in use"
**Solution:**
```bash
# Find process using port 3000
# On Windows: netstat -ano | findstr :3000
# Kill process or use different port in .env

# In backend .env:
PORT=3001  # Change to different port
```

### Issue: "MongoDB connection refused"
**Solution:**
```bash
# Check MongoDB is running:
mongo

# If not running:
# Windows: Services > MongoDB > Start
# Mac: brew services start mongodb-community
# Linux: sudo service mongod start
```

### Issue: "CORS error" connecting to backend
**Solution:**
```bash
# In backend (server.js or app.js):
const cors = require('cors');
app.use(cors());

# Update Flutter app API URL:
# lib/core/constants/app_constants.dart
const String baseUrl = 'http://10.0.2.2:3000/api';
# (10.0.2.2 is emulator's localhost)
```

### Issue: Duplicate icons still showing
**Solution:**
```bash
# Make sure main.dart is the main entry point:
# In main.dart, verify:
void main() {
  runApp(const MyApp());
}

# NOT from any feature file
```

### Issue: App won't hot reload
**Solution:**
```bash
# Restart app:
flutter run

# With full rebuild:
flutter clean
flutter pub get
flutter run
```

---

## 📡 API BASE URL SETUP

### For Local Development:
```dart
// lib/core/constants/app_constants.dart
const String baseUrl = 'http://10.0.2.2:3000/api';
```

### For Real Device (same network):
```dart
// Replace YOUR_PC_IP with your computer's IP
// Find IP: Windows cmd > ipconfig (look for IPv4 Address)
const String baseUrl = 'http://YOUR_PC_IP:3000/api';
```

### For Production:
```dart
const String baseUrl = 'https://your-deployed-backend.com/api';
```

---

## 📝 FILE STRUCTURE RECAP

```
flightbuddy-1/
├── lib/
│   ├── main.dart                          ← ENTRY POINT (Single)
│   ├── features/
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── dashboard_screen.dart  ← HOME TAB
│   │   ├── search/
│   │   │   └── search_screen.dart         ← SEARCH TAB
│   │   ├── alerts/
│   │   │   └── alerts_screen.dart         ← ALERTS TAB
│   │   ├── messages/
│   │   │   └── message_screen.dart        ← MESSAGES TAB
│   │   ├── profile/
│   │   │   └── profile_screen.dart        ← PROFILE TAB
│   │   └── flights/
│   │       └── search_results_screen.dart ← Flight results
│   └── core/
│       └── constants/
│           └── app_constants.dart         ← API URLs (create if needed)
│
├── SETUP_GUIDE.md                         ← Backend setup
├── BACKEND_SETUP.md                       ← Detailed backend config
├── IMPLEMENTATION_COMPLETE.md             ← Feature verification
└── VISUAL_GUIDE.md                        ← UI/UX reference

flightbuddy-backend/
├── server.js                              ← Entry point
├── models/
│   ├── user_model.js
│   ├── flight_model.js
│   └── booking_model.js
├── routes/
│   ├── user_route.js
│   ├── flight_route.js
│   └── booking_route.js
├── controllers/
│   └── ...
├── middleware/
│   └── ...
├── config/
│   └── db.js
├── .env                                   ← Create this!
└── package.json
```

---

## 🎯 NEXT STEPS (IN ORDER)

### Phase 1: Frontend ✅
- [x] Clean up duplicate icons
- [x] Create single entry point
- [x] Implement 5 tabs
- [x] Add flight booking logic
- [x] Test UI/UX

### Phase 2: Backend Setup
- [ ] Configure `.env` file
- [ ] Start MongoDB
- [ ] Start Node.js server
- [ ] Create API endpoints
- [ ] Test endpoints with Postman

### Phase 3: Integration
- [ ] Update API URLs in Flutter
- [ ] Integrate flight search API
- [ ] Integrate booking API
- [ ] Integrate user authentication
- [ ] Integrate payments (Stripe/Razorpay)

### Phase 4: Production
- [ ] Deploy backend to cloud
- [ ] Update API URLs
- [ ] Build APK for Android
- [ ] Submit to App Store/Play Store

---

## 💡 PRO TIPS

1. **Use Postman** to test backend APIs before connecting Flutter
2. **Enable Flutter DevTools** for debugging
3. **Keep `.env` secure** - add to .gitignore
4. **Use git branches** for different features
5. **Test on both Android & iOS** emulators
6. **Monitor network** in Flutter DevTools when testing APIs

---

## 📞 COMMON API ENDPOINTS TO TEST

Once backend is running, open Postman and test these:

```
GET http://localhost:3000/api/health
→ Should return: {"status": "OK"}

GET http://localhost:3000/api/flights/search?from=Nepal&to=Bangalore
→ Should return array of flights

POST http://localhost:3000/api/auth/register
→ Request body: {"email": "user@test.com", "password": "123456"}

POST http://localhost:3000/api/bookings/create
→ Request body: flight booking data
```

---

## 🔒 SECURITY REMINDERS

- ✅ Never commit `.env` file to git
- ✅ Use environment variables for sensitive data
- ✅ Validate all user inputs on backend
- ✅ Use HTTPS in production
- ✅ Implement proper authentication (JWT)
- ✅ Sanitize database queries to prevent SQL injection
- ✅ Rate limit API endpoints
- ✅ Use secure password hashing (bcryptjs)

---

## 📊 PERFORMANCE TIPS

- Use `const` constructors where possible (done!)
- Implement lazy loading for large lists
- Cache frequently used data
- Optimize images in assets
- Use proper pagination for search results
- Implement connection pooling for database

---

## 🎓 LEARNING RESOURCES

- **Flutter Docs**: https://flutter.dev/docs
- **Dart Docs**: https://dart.dev/guides
- **Express.js Docs**: https://expressjs.com/
- **MongoDB Docs**: https://docs.mongodb.com/
- **REST API Best Practices**: https://restfulapi.net/

---

## ✨ YOU'RE ALL SET!

Your FlightBuddy app is ready to be launched! 🚀

**Current Status:**
- ✅ Frontend: 100% Complete
- 📝 Backend: Ready for setup
- 🔗 Integration: Ready after backend setup

**Next Action:** Start your backend server and integrate APIs!

---

Questions? Check the documentation files:
- `SETUP_GUIDE.md` - Complete overview
- `BACKEND_SETUP.md` - Backend configuration
- `IMPLEMENTATION_COMPLETE.md` - Features list
- `VISUAL_GUIDE.md` - UI reference
