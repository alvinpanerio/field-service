import 'package:field_service_client/widgets/worksheet/floating_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeAreaWidget extends StatefulWidget {
  const SafeAreaWidget(this.screen, this.state, {Key? key}) : super(key: key);

  final Widget screen;
  final GoRouterState state;

  @override
  State<SafeAreaWidget> createState() => _SafeAreaWidgetState();
}

class _SafeAreaWidgetState extends State<SafeAreaWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.state.path == "/task/:id"
            ? AppBar(leading: const BackButton())
            : null,
        floatingActionButton: widget.state.path == "/task/:id"
            ? FloatingActionWidget(state: widget.state)
            : null,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: widget.screen,
        ),
      ),
    );
  }
}
