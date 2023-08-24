import 'package:field_service_client/bloc/odoo_models/odoo_models_bloc.dart';
import 'package:field_service_client/bloc/service/service_bloc.dart';
import 'package:field_service_client/bloc/worksheet/worksheet_bloc.dart';
import 'package:field_service_client/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/user/user_bloc.dart';
import 'bloc/task/task_bloc.dart';
import 'models/user.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc()
            ..add(
              const SetUser(),
            ),
        ),
        BlocProvider(
          create: (context) => ServiceBloc()
            ..add(
              const GetServices(),
            ),
        ),
        BlocProvider(
          create: (context) => WorksheetBloc()
            ..add(
              const GetWorksheet(),
            ),
        ),
        BlocProvider(
          create: (context) => TaskBloc()
            ..add(
              const GetTask(),
            ),
        ),
        BlocProvider(
          create: (context) => OdooModelsBloc()
            ..add(
              const GetOdooModels(),
            ),
        )
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            User user = state.user;
            return MaterialApp.router(
              title: 'AWB Field Service',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: GoogleFonts.montserrat().fontFamily,
                primaryColor: const Color(0xff323264),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xff323264),
                ),
                textTheme: const TextTheme(
                  displayLarge: TextStyle(
                    fontSize: 68,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff323264),
                  ),
                  titleLarge: TextStyle(fontSize: 36),
                  bodyMedium: TextStyle(fontSize: 14),
                ),
                useMaterial3: true,
              ),
              routeInformationParser:
                  AppRouter.returnRouter(user.name.isNotEmpty)
                      .routeInformationParser,
              routerDelegate:
                  AppRouter.returnRouter(user.name.isNotEmpty).routerDelegate,
            );
          } else {
            return const MaterialApp(
              home: Text("went wrong"),
            );
          }
        },
      ),
    );
  }
}
