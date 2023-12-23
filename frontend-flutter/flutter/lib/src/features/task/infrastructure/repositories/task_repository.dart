import 'package:fpdart/fpdart.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/core/domain/failures/http_connection_failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';
import 'package:task_app/src/features/task/domain/repositories/task_repository_interface.dart';
import 'package:task_app/src/features/task/infrastructure/datasources/local/task_local_data_source.dart';
import 'package:task_app/src/features/task/infrastructure/datasources/remote/task_remote_datasource.dart';

/// Task Repository.
class TaskRepository implements TaskRepositoryInterface {
  final TaskRemoteDataSource taskRemoteDataSource;
  final TaskLocalDataSource taskLocalDataSource;

  TaskRepository(
      {required this.taskRemoteDataSource, required this.taskLocalDataSource});

  /// Get [TaskEntity] by `id`.
  @override
  Future<Either<Failure, TaskEntity>> getTask(BigInt id) async {
    final response = await taskRemoteDataSource.get(id);
    return await response.fold((failure) async {
      if (failure is HttpConnectionFailure) {
        return await taskLocalDataSource.get(id);
      }
      return left(failure);
    }, (balance) async {
      // Store balance data
      await taskLocalDataSource.put(balance);
      return right(balance);
    });
  }

  /// Get a list of [TaskEntity].
  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(final int page) async {
    final response = await taskRemoteDataSource.list(page: page);
    return await response.fold((failure) async {
      if (failure is HttpConnectionFailure) {
        return await taskLocalDataSource.list();
      }
      return left(failure);
    }, (taskList) async {
      // Store balances data
      for (final task in taskList) {
        await taskLocalDataSource.put(task);
      }
      return right(taskList);
    });
  }

  /// Store a [TaskEntity].
  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    return await taskRemoteDataSource.create(task);
  }

  /// Update a [TaskEntity].
  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    return await taskRemoteDataSource.update(task);
  }

  /// Delete a [TaskEntity].
  @override
  Future<Either<Failure, void>> deleteTask(TaskEntity task) async {
    await taskLocalDataSource.delete(task.id!);
    return await taskRemoteDataSource.delete(task.id!);
  }
}
