import 'package:fpdart/fpdart.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';

/// Task Repository Interface.
abstract class TaskRepositoryInterface {
  /// Get [TaskEntity] by `id`.
  Future<Either<Failure, TaskEntity>> getTask(BigInt id);

  /// Get a list of [TaskEntity].
  Future<Either<Failure, List<TaskEntity>>> getTasks(final int page);

  /// Store a [TaskEntity].
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);

  /// Update a [TaskEntity].
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);

  /// Delete a [TaskEntity].
  Future<Either<Failure, void>> deleteTask(TaskEntity task);
}
