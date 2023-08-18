import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:field_service_client/app.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(
    const App(),
  );
}
