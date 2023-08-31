import 'package:flutter/material.dart';
import 'package:field_service_client/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(
    const App(),
  );
}
