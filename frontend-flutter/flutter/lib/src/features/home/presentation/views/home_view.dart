import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/src/core/utils/widget_utils.dart';
import 'package:task_app/src/features/task/presentation/views/task_list_view.dart';
import 'package:task_app/src/features/task/providers.dart';

class HomeView extends ConsumerWidget {
  /// Named route for [HomeView]
  static const String routeName = 'home';

  /// Path route for [HomeView]
  static const String routePath = 'home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListSate = ref.watch(taskListControllerProvider);

    return Scaffold(
        body: SafeArea(
      child: taskListSate.when(
          data: (taskList) {
            return TaskListView(
              taskList: taskList,
            );
          },
          loading: showLoading,
          error: (error, _) => showError(error: error)),
    ));
  }
}
