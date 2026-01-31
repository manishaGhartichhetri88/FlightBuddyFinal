import 'package:flightbuddy/app/app.dart';
import 'package:flightbuddy/core/constants/hive_table_constant.dart';
import 'package:flightbuddy/core/services/storage/user_session_service.dart';
import 'package:flightbuddy/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/home/home_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();

  // ✅ Register adapters
  Hive.registerAdapter(AuthHiveModelAdapter());

  // ✅ Open your auth box once at startup
  await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);

  // Shared Pref object
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPrefs),
    ],
    child: MyApp()));
}
