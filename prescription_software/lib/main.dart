import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prescription_software/screens/login_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    windowManager.ensureInitialized();
    // windowManager.setFullScreen(true);
    // windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
