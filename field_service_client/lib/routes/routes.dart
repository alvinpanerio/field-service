import 'dart:js_interop';

import 'package:field_service_client/bloc/user/user_bloc.dart';
import 'package:field_service_client/screens/home_screen.dart';
import 'package:field_service_client/screens/login_screen.dart';
import 'package:field_service_client/screens/task_item_screen.dart';
import 'package:field_service_client/screens/tasks_screen.dart';
import 'package:field_service_client/widgets/bottom_navbar_widget.dart';
import 'package:field_service_client/widgets/safe_area_widget.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter returnRouter(bool isAuth) {
    GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              child: BottomNavbarWidget(location: state.location, child: child),
            );
          },
          routes: [
            GoRoute(
              name: "login",
              path: '/login',
              redirect: ((context, state) => _redirect(context, state)),
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: SafeAreaWidget(
                    const LoginScreen(),
                    state,
                  ),
                );
              },
            ),
            GoRoute(
              name: "home",
              path: '/',
              redirect: ((context, state) => _redirect(context, state)),
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: SafeAreaWidget(
                    const HomeScreen(),
                    state,
                  ),
                );
              },
            ),
            GoRoute(
              name: "tasks",
              path: '/tasks',
              redirect: ((context, state) => _redirect(context, state)),
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: SafeAreaWidget(
                    const TasksScreen(),
                    state,
                  ),
                );
              },
            ),
            GoRoute(
              name: "taskItem",
              path: '/task/:id',
              redirect: ((context, state) => _redirect(context, state)),
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: SafeAreaWidget(
                    TaskItemScreen(state.params),
                    state,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );

    return router;
  }

  static Future<String?> _redirect(context, state) async {
    final user = await go();
    if (user) {
      return "/login";
    }
    if (state.location == "/login" && !user) {
      return "/";
    }
    return null;
  }

  static Future<bool> go() async {
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;
    return prefs.getString('user').isNull;
  }
}
