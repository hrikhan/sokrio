import 'package:flutter/material.dart';
import 'app/app.dart';
import 'injection_container.dart' as di;

//main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}
