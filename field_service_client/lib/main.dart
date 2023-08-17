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
    controller = CameraController(cameras![0], ResolutionPreset.max);
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

    Uint8List _convertBase64Image(String base64String) {
      return const Base64Decoder().convert(base64String.split(',').last);
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

                                    final data = await rawImage.readAsBytes();

                                    ui.Image image =
                                        await decodeImageFromList(data);

                                    final bytes = await image.toByteData(
                                        format: ui.ImageByteFormat.png);

                                    setState(() {
                                      widget.picture = base64
                                          .encode(bytes!.buffer.asUint8List())
                                          .toString();
                                    });

                                    controller = CameraController(
                                        cameras![0], ResolutionPreset.max);
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
                            // Image.memory(
                            //   const Base64Decoder().convert(
                            //       widget.picture.toString().split(',').last),
                            //   gaplessPlayback: true,
                            // ),
                            FilledButton.tonal(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  // fixedSize: const Size(60, 60),
                                ),
                                onPressed: () {
                                  controller = CameraController(
                                      cameras![0], ResolutionPreset.max);
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
        Image.memory(
          _convertBase64Image(widget.picture.toString()),
          gaplessPlayback: true,
        ),
      ],
    );
  }
}
