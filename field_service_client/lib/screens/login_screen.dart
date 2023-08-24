import 'package:field_service_client/bloc/service/service_bloc.dart';
import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:requests/requests.dart';
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

  bool loginState = false;

  @override
  Widget build(BuildContext context) {
    void login() async {
      setState(() {
        loginState = false;
      });

      final rawResponse = await apiProvider.post(
        "/login",
        {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (rawResponse.runtimeType != HTTPException) {
        final response = rawResponse;

        final SharedPreferences prefs = await _prefs;
        prefs.setString('user', response["name"].toString());

        context.push("/");
      } else {
        setState(() {
          loginState = true;
        });
      }
    }

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const CircularProgressIndicator();
        }
        if (state is UserLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 20),
                Material(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                      errorText: loginState ? "Username not exists!" : null,
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
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      errorText: loginState ? "Password invalid!" : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: login,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text("went wrong");
        }
      },
    );
  }
}
