import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/app_colors.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/widgets/app_title.dart';
import 'package:task_app/src/features/home/presentation/views/home_view.dart';
import 'package:task_app/src/features/task/presentation/widgets/task_create_form.dart';

class TaskCreateView extends ConsumerWidget {
  /// Route name
  static const routeName = 'taskCreate';

  /// Route path
  static const routePath = 'create';

  const TaskCreateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: TaskCreateForm(),
    );
  }
}
