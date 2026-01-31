import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

static const bool isPhysicalDevice = false;

static const String compIpAddress = "192.168.1.100"; // Replace with your computer's IP address

  static String get baseUrl {
    if(isPhysicalDevice) {
      return 'http://$compIpAddress:3000/api/v1';
    }
    //if android
    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  } 

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ user Endpoints ============
  static const String users = '/users';
  static const String userLogin = '/users/login';
  static String userById(String id) => '/users/$id';
  static String userPhoto(String id) => '/users/$id/photo';

}