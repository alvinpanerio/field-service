import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeAreaHomeTasks extends StatefulWidget {
  const SafeAreaHomeTasks(this.screen, {Key? key}) : super(key: key);
  final Widget screen;

  @override
  State<SafeAreaHomeTasks> createState() => _SafeAreaHomeTasksState();
}

class _SafeAreaHomeTasksState extends State<SafeAreaHomeTasks> {
  Future<void> _logout() async {
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    final SharedPreferences prefs = await pref;
    await prefs.remove('user');
    context.pop();
    context.push("/login");
  }

  Future<dynamic> _accountDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alvin Panerio",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text("alvin.panerio@gmail.com")
                  ],
                )
              ],
            ),
            TextButton(
              onPressed: _logout,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.logout_rounded),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Log out this account")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
              onPressed: _accountDialog,
              icon: const Icon(Icons.account_circle),
              label: const Text(""),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: widget.screen,
        ),
      ),
    );
  }
}
