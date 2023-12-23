import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/config/providers.dart';
import 'package:task_app/src/features/task/application/task_list_controller.dart';
import 'package:task_app/src/features/task/domain/repositories/task_repository_interface.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';
import 'package:task_app/src/features/task/infrastructure/datasources/local/task_local_data_source.dart';
import 'package:task_app/src/features/task/infrastructure/datasources/remote/task_remote_datasource.dart';
import 'package:task_app/src/features/task/infrastructure/repositories/task_repository.dart';

///
/// Infrastructure dependencies
///

/// Task repository
final taskRepositoryProvider = Provider<TaskRepositoryInterface>((ref) =>
    TaskRepository(
        taskRemoteDataSource:
            TaskRemoteDataSource(apiClient: ref.read(apiClientProvider)),
        taskLocalDataSource: TaskLocalDataSource(
            localDbClient: ref.read(localDbClientProvider))));

///
/// Application dependencies
///

final taskListControllerProvider =
    StateNotifierProvider<TaskListController, AsyncValue<List<TaskEntity>>>(
        (ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return TaskListController(repository: repo);
});
