import 'package:field_service_client/bloc/service/service_bloc.dart';

import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user/user_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    void go(response) {
      context.read<UserBloc>().add(SetUser(
          name: response["name"].toString(),
          cookies: response["name"].toString()));

      context
          .read<ServiceBloc>()
          .add(SetServices(services: response["services"]));
    }

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {},
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Material(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                try {
                  final response = await apiProvider.login(
                    emailController.text,
                    passwordController.text,
                    context,
                  );

                  final SharedPreferences prefs = await _prefs;

                  prefs.setString('user', response["name"].toString());

                  // context.read<UserBloc>().add(SetUser(
                  //     name: response["name"].toString(),
                  //     cookies: response["name"].toString()));

                  // context
                  //     .read<ServiceBloc>()
                  //     .add(SetServices(services: response["services"]));

                  context.push("/");
                } catch (e) {
                  // Handle the error, log it, or show an error message
                  print("An error occurred: $e");
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
