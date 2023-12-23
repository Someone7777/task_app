import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/config/api_client.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';
import 'package:task_app/src/features/task/presentation/widgets/task_card.dart';

class TaskListView extends ConsumerWidget {
  final List<TaskEntity> taskList;

  const TaskListView({required this.taskList, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = connectionStateListenable.value;

    return Stack(children: <Widget>[
      ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskCard(taskEntity: taskList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.bottomCenter,
        child: isConnected
            ? FloatingActionButton(
                onPressed: () async {
                  //context.push(
                  //      "/${TaskView.routePath}/${TaskCreateView.routePath}");
                },
                backgroundColor: Colors.grey,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    ]);
  }
}
