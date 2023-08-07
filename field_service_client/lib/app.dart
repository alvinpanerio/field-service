import 'package:field_service_client/routes/routes.dart';
import 'package:flutter/material.dart';
import 'dart:html';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff333267),
        ),
        useMaterial3: true,
      ),
      routeInformationParser:
          AppRouter.returnRouter(document.cookie!.isNotEmpty)
              .routeInformationParser,
      routerDelegate:
          AppRouter.returnRouter(document.cookie!.isNotEmpty).routerDelegate,
    );
  }
}
