import 'package:field_service_client/screens/home_screen.dart';
import 'package:field_service_client/screens/login_screen.dart';
import 'package:field_service_client/widgets/safe_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter returnRouter(bool isAuth) {
    GoRouter router = GoRouter(
      routes: [
        GoRoute(
          name: "login",
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(
                child: SafeAreaWidget(
              LoginScreen(),
            ));
          },
        ),
        GoRoute(
          name: "home",
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(
                child: SafeAreaWidget(
              HomeScreen(),
            ));
          },
        ),
      ],
      initialLocation: "/",
      redirect: (context, state) {
        if (isAuth) {
          print(isAuth);
          return "/";
        } else {
          print(isAuth);
          return '/login';
        }
      },
    );
    return router;
  }
}
