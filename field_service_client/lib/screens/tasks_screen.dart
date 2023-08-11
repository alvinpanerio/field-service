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
      children: [
        const Text("Tasks"),
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
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        return GoRouter.of(context).push(
                          "/task/${service[i]['id'].toString()}",
                        );
                      },
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
