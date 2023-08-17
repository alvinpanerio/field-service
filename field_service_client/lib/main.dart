import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:field_service_client/widgets/worksheet/fields_value.dart';
import 'package:flutter/material.dart';
import 'package:field_service_client/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;

List<CameraDescription>? cameras;
Future main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(
    const App(),
  );
}

class CameraPage extends StatefulWidget {
  CameraPage({Key? key, required this.title, required this.picture})
      : super(key: key);
  final String title;

  String? picture;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  String imagePath = "";
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras![1], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        FilledButton.tonal(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => Material(
              type: MaterialType.transparency,

              // Aligns the container to center
              child: Scaffold(
                body: SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        CameraPreview(controller!),
                        Row(
                          children: [
                            FilledButton.tonal(
                                onPressed: () async {
                                  try {
                                    final rawImage =
                                        await controller!.takePicture();

                                    // final bytes = await rawImage.readAsBytes();
                                    // final image = await File('image.png')
                                    //     .writeAsBytes(bytes);
                                    // print("eto");
                                    // print(image);

                                    final image = Image.network(
                                        File(rawImage.path).toString());

                                        

                                    print(image);

                                    setState(() {
                                      // widget.picture = base64.encode(bytes);
                                    });
                                    print(widget.picture);
                                    controller = CameraController(
                                        cameras![1], ResolutionPreset.max);
                                    controller?.initialize().then((_) {
                                      if (!mounted) {
                                        return;
                                      }
                                      setState(() {});
                                    });
                                    context.pop();
                                  } catch (e) {
                                    // ignore: avoid_print
                                    print(e);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  // fixedSize: const Size(60, 60),
                                ),
                                child: const Icon(Icons.check)),
                            FilledButton.tonal(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  // fixedSize: const Size(60, 60),
                                ),
                                onPressed: () {
                                  controller = CameraController(
                                      cameras![1], ResolutionPreset.max);
                                  controller?.initialize().then((_) {
                                    if (!mounted) {
                                      return;
                                    }
                                    setState(() {});
                                  });
                                  context.pop();
                                },
                                child: const Icon(Icons.close))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: const Text("OpenCamera"),
        ),
      ],
    );
  }
}
