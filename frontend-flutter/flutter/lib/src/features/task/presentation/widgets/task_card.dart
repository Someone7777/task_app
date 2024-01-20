import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_app/config/api_client.dart';
import 'package:task_app/config/app_layout.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';
import 'package:task_app/src/features/task/presentation/views/task_edit_view.dart';

class TaskCard extends ConsumerWidget {
  final TaskEntity taskEntity;
  final dateFormat = DateFormat("dd-MM-yyyy");

  TaskCard({required this.taskEntity, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = connectionStateListenable.value;

    return GestureDetector(
      onTap: () {
        router.pushNamed(TaskEditView.routeName,
            queryParameters: {"id": "${taskEntity.id}"});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        ),
        color: Theme.of(context).brightness == Brightness.light
            ? const Color.fromARGB(255, 232, 234, 246)
            : const Color.fromARGB(255, 123, 127, 148),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.task_outlined),
              title: Text(taskEntity.title, overflow: TextOverflow.ellipsis),
              subtitle:
                  Text(taskEntity.description, overflow: TextOverflow.ellipsis),
              trailing: Text(dateFormat.format(taskEntity.deadline)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      // If the button is pressed, return grey, otherwise red
                      if (states.contains(MaterialState.pressed) ||
                          states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.red;
                    }),
                  ),
                  onPressed: (isConnected)
                      ? () async {
                          // TODO add delete operation
                        }
                      : null,
                  child: const Icon(
                    Icons.delete,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
