import 'package:flutter/material.dart';
import 'package:field_service_client/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const App(),
  );
}
