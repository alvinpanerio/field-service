import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbarWidget extends StatefulWidget {
  const BottomNavbarWidget(
      {super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  State<BottomNavbarWidget> createState() => _BottomNavbarWidgetState();
}

class _BottomNavbarWidgetState extends State<BottomNavbarWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: GoRouter.of(context).location == "/login"
          ? null
          : NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });

                switch (currentPageIndex) {
                  case 0:
                    {
                      GoRouter.of(context).push("/");
                    }
                    break;

                  case 1:
                    {
                      GoRouter.of(context).push("/tasks");
                    }
                    break;
                }
              },
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home_rounded),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.task_rounded),
                  icon: Icon(Icons.task_outlined),
                  label: 'My Tasks',
                ),
              ],
            ),
    );
  }
}
