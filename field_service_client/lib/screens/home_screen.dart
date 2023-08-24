import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:requests/requests.dart';
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

  @override
  void initState() {
    super.initState();
    getName();
    getAllTasks();
  }

  Future<void> getName() async {
    final rawResponse = await apiProvider.get(
      "/name",
    );

    if (rawResponse.runtimeType != HTTPException) {
      final response = rawResponse;

      // context.read<UserBloc>().add(SetUser(
      //     user: User(
      //         name: response["name"].toString(),
      //         cookies: response["name"].toString())));
    } else {
      return;
    }
  }

  Future<void> getAllTasks() async {
    final rawResponse = await apiProvider.get(
      "/all-tasks",
    );

    if (rawResponse.runtimeType != HTTPException) {
      final response = rawResponse;

      context
          .read<ServiceBloc>()
          .add(SetServices(services: response["services"]));
    } else {
      return;
    }
  }

  Uint8List _convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }

  Color setColorStatus(String status) {
    switch (status) {
      case "New":
        return Colors.lightBlue;
      case "Planned":
        return Colors.yellow;
      case "In Progress":
        return Colors.green;
      case "To Invoice":
        return Colors.orange;
      case "Done":
        return Colors.purple;
      case "Cancelled":
        return Colors.red;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          "All Tasks",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
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
              height: MediaQuery.of(context).size.height - 245,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: service.length,
                itemBuilder: (v, i) => ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service[i]['name'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Badge(
                        backgroundColor: setColorStatus(
                          service[i]["stage_id"][1].toString(),
                        ),
                        label: Text(
                          service[i]["stage_id"][1].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    print("asd");
                  },
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service[i]['partner_id'] == false
                          ? 'None'
                          : service[i]['partner_id'][1].toString()),
                      Text(service[i]['project_id'][0].toString()),
                      Text(service[i]['project_id'][1].toString()),
                      service[i]['user_ids'].isEmpty ||
                              service[i]['user_ids'][0].isEmpty
                          ? const SizedBox.shrink()
                          : Row(
                              children: <Widget>[
                                for (var item in service[i]['user_ids'])
                                  CircleAvatar(
                                    backgroundImage: MemoryImage(
                                        _convertBase64Image(
                                            item[0]["avatar_128"])),
                                  )
                              ],
                            ),
                    ],
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
