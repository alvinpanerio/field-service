import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              apiProvider.login(emailController.text, passwordController.text);
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
          FilledButton(
            onPressed: () {
              apiProvider.getCookies();
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
    );
  }
}
