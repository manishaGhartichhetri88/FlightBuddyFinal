# Backend Configuration Template

Create this file as `.env` in your flightbuddy-backend root folder

```env
################################
# MONGODB CONFIGURATION
################################
# Local MongoDB
LOCAL_DATABASE_URI=mongodb://localhost:27017/flightbuddy

# MongoDB Atlas (Cloud) - Uncomment and update if using cloud
# LOCAL_DATABASE_URI=mongodb+srv://username:password@cluster.mongodb.net/flightbuddy?retryWrites=true&w=majority

# MongoDB Credentials (if using authentication)
MONGO_USER=flightbuddy_user
MONGO_PASSWORD=secure_password_here

################################
# SERVER CONFIGURATION
################################
PORT=3000
NODE_ENV=development
BASE_URL=http://localhost:3000

################################
# JWT AUTHENTICATION
################################
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=7d

################################
# CORS CONFIGURATION
################################
CORS_ORIGIN=http://localhost:3000,http://10.0.2.2:3000

################################
# EMAIL CONFIGURATION (For booking confirmations)
################################
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
# Generate App Password from Google: https://myaccount.google.com/apppasswords
SMTP_PASSWORD=your_16_char_app_password

EMAIL_FROM_NAME=FlightBuddy
EMAIL_FROM_EMAIL=noreply@flightbuddy.com

################################
# PAYMENT GATEWAY (Stripe)
################################
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_public_key

################################
# SMS CONFIGURATION (Twilio - Optional)
################################
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_PHONE_NUMBER=+1234567890

################################
# LOGGING
################################
LOG_LEVEL=debug
LOG_FILE=logs/app.log

################################
# RATE LIMITING
################################
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100
```

---

## 📋 Step-by-Step Backend Setup

### 1. Create `.env` file
Copy the above configuration into a new file called `.env` in your backend root

### 2. Install Dependencies
```bash
cd flightbuddy-backend
npm install
```

### 3. Install MongoDB (if not installed)

**Windows:**
- Download from: https://www.mongodb.com/try/download/community
- Run installer and follow setup
- MongoDB will run as a service

**Mac:**
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

**Linux (Ubuntu):**
```bash
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
```

### 4. Verify MongoDB is Running
```bash
mongo --version
# Should show version number

# Connect to MongoDB
mongo
# Should show connection message
```

### 5. Start Backend Server
```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start

# Or if using nodemon
npx nodemon server.js
```

**Expected Output:**
```
[nodemon] starting `node server.js`
Connecting to MongoDB...
MongoDB connected to : 127.0.0.1:27017
Server running in development mode on port 3000
API Documentation: http://localhost:3000/api-docs
```

### 6. Test Backend is Working
Open browser and visit: `http://localhost:3000/api/health`
Should return: `{ "status": "OK", "message": "Server is running" }`

---

## 🔗 Required Backend Dependencies

Your `package.json` should have (install with `npm install`):

```json
{
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.0.0",
    "dotenv": "^16.0.3",
    "cors": "^2.8.5",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0",
    "nodemailer": "^6.9.0",
    "express-validator": "^7.0.0",
    "multer": "^1.4.5-lts.1",
    "stripe": "^12.0.0"
  }
}
```

---

## ✅ Checklist Before Running

- [ ] MongoDB is installed and running
- [ ] `.env` file is created in backend root
- [ ] `npm install` completed
- [ ] All required environment variables are set in `.env`
- [ ] Port 3000 is not in use by another application
- [ ] Backend server starts without errors
- [ ] Flutter app has correct API base URL

**Once backend is running, Flutter app can connect to it!**
