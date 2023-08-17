import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/service/service_bloc.dart';
import '../models/user.dart';
import '../bloc/user/user_bloc.dart';
import '../utils/api_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiProvider apiProvider = ApiProvider();

  Future<void> go(pref) async {
    final SharedPreferences prefs = await pref;
    await prefs.remove('user');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            User user = state.user;
            return Text("Hello, ${user.name}!");
          } else {
            return const Text("went wrong");
          }
        },
      ),
      const SizedBox(height: 10),
      BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tasks"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final response = await apiProvider.getAllTasks();
                    context
                        .read<ServiceBloc>()
                        .add(SetServices(services: response["services"]));
                  },
                  child: const Text("All tasks"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final response = await apiProvider.getMyTasks();
                    context
                        .read<ServiceBloc>()
                        .add(SetServices(services: response["services"]));
                  },
                  child: const Text("My tasks"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final Future<SharedPreferences> prefs =
                        SharedPreferences.getInstance();
                    go(prefs);
                    context.push("/login");
                  },
                  child: const Text("All tasks"),
                ),
              ],
            )
          ],
        ),
      ),
      const SizedBox(height: 10),
      BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ServiceLoaded) {
            List<dynamic> service = state.service;

            return SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: ListView.builder(
                itemCount: service.length,
                itemBuilder: (v, i) => Card(
                  key: UniqueKey(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 230,
                                child: Text(
                                  "Project Name: ${service[i]['name'].toString()}",
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                width: 230,
                                child: Text(
                                  "Customer: ${service[i]['partner_id'] == false ? 'None' : service[i]['partner_id'][1].toString()}",
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                  "ID: ${service[i]['project_id'][0].toString()}"),
                              Text(
                                  "Type: ${service[i]['project_id'][1].toString()}"),
                              Text(
                                  "User IDs: ${service[i]['user_ids'].toString()}"),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            );
          } else {
            return const Text("went wrong");
          }
        },
      )
    ]);
  }
}
