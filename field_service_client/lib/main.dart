import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:field_service_client/app.dart';
import 'package:go_router/go_router.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
    const App(),
  );
}

// Future<void> getAllAsync() async {
//   await dotenv.load(fileName: ".env");

//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
// }

// class CameraPage extends StatefulWidget {
//   CameraPage({Key? key, required this.title, required this.picture})
//       : super(key: key);
//   final String title;

//   String? picture;

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   @override
//   Widget build(BuildContext context) {
//     if (!controller!.value.isInitialized) {
//       return Container();
//     }

//     Uint8List _convertBase64Image(String base64String) {
//       return const Base64Decoder().convert(base64String.split(',').last);
//     }

//     return Column(
//       children: [
//         const SizedBox(
//           height: 50,
//         ),
//       ],
//     );
//   }
// }
