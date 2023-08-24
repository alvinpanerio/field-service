import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/service/service_bloc.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  ApiProvider apiProvider = ApiProvider();
  @override
  void initState() {
    super.initState();
    _fetchMyTasks();
  }

  Future<void> _fetchMyTasks() async {
    final response = await apiProvider.getMyTasks();

    context
        .read<ServiceBloc>()
        .add(SetServices(services: response["services"]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "My Tasks",
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
                height: MediaQuery.of(context).size.height - 235,
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
                          backgroundColor: Colors.green,
                          label: Text(
                            service[i]["stage_id"][1].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () => GoRouter.of(context).push(
                      "/task/${service[i]['id'].toString()}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service[i]['partner_id'] == false
                            ? 'None'
                            : service[i]['partner_id'][1].toString()),
                        Text(service[i]['project_id'][0].toString()),
                        Text(service[i]['project_id'][1].toString()),
                        Text(service[i]['user_ids'].toString()),
                      ],
                    ),
                  ),
                ),
              );
              // return Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     for (var i in service)
              //       Card(
              //         child: Row(children: [
              //           Text(i['name'].toString()),
              //           Text(i['project_id'][0].toString()),
              //           Text(i['project_id'][1].toString()),
              //           Text(i['user_ids'].toString()),
              //         ]),
              //       )
              //   ],
              // );
            } else {
              return const Text("went wrong");
            }
          },
        )
      ],
    );
  }
}
