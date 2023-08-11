import 'package:field_service_client/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task/task_bloc.dart';

class TaskItemScreen extends StatefulWidget {
  const TaskItemScreen(this.param, {Key? key}) : super(key: key);

  final Map<String, String> param;

  @override
  State<TaskItemScreen> createState() => _TaskItemScreenState();
}

class _TaskItemScreenState extends State<TaskItemScreen> {
  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    _fetchTask();
  }

  Future<void> _fetchTask() async {
    Map<String, String> id = widget.param;

    final response = await apiProvider.getTask(id["id"]!);

    context.read<TaskBloc>().add(GetTask(task: response["task"]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: Text("loading"));
        }
        if (state is TaskLoaded) {
          List<dynamic> task = state.task;

          return ListView.builder(
            itemCount: task.length,
            itemBuilder: (BuildContext context, int index) => Column(
              children: [
                Text(
                  task[0]["id"].toString(),
                ),
                Text(
                  task[0]["partner_id"][1].toString(),
                ),
                Text(
                  task[0]["partner_phone"].toString(),
                ),
                Text(
                  task[0]["sale_line_id"].toString(),
                ),
                Text(
                  task[0]["planned_date_begin"].toString(),
                ),
                Text(
                  task[0]["tag_ids"].toString(),
                ),
                Text(
                  task[0]["user_ids"].toString(),
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
