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
    int currentPageIndex = 0;
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: NavigationBar(
        //   onDestinationSelected: (int index) {
        //     setState(() {
        //       currentPageIndex = index;
        //     });

        //     switch (currentPageIndex) {
        //       case 0:
        //         {
        //           GoRouter.of(context).push("/");
        //         }
        //         break;

        //       case 1:
        //         {
        //           GoRouter.of(context).push("/tasks");
        //         }
        //         break;
        //     }
        //   },
        //   selectedIndex: currentPageIndex,
        //   destinations: const <Widget>[
        //     NavigationDestination(
        //       selectedIcon: Icon(Icons.home_rounded),
        //       icon: Icon(Icons.home_outlined),
        //       label: 'Home',
        //     ),
        //     NavigationDestination(
        //       selectedIcon: Icon(Icons.task_rounded),
        //       icon: Icon(Icons.task_outlined),
        //       label: 'My Tasks',
        //     ),
        //   ],
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
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
