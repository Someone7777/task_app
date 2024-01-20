import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/app_colors.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/widgets/app_title.dart';
import 'package:task_app/src/core/utils/widget_utils.dart';
import 'package:task_app/src/features/home/presentation/views/home_view.dart';
import 'package:task_app/src/features/task/presentation/widgets/task_edit_form.dart';
import 'package:task_app/src/features/task/providers.dart';

class TaskEditView extends ConsumerWidget {
  /// Route name
  static const routeName = 'taskEdit';

  /// Route path
  static const routePath = 'edit';

  final int id;

  const TaskEditView({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListSate = ref.watch(taskListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(fontSize: 30),
        backgroundColor: AppColors.appBarBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              navigatorKey.currentContext!.goNamed(HomeView.routeName),
        ),
      ),
      body: taskListSate.when(
          data: (taskList) {
            return TaskEditForm(
              task: taskList.firstWhere((element) => element.id == id),
            );
          },
          loading: showLoading,
          error: (error, _) => showError(error: error)),
    );
  }
}
