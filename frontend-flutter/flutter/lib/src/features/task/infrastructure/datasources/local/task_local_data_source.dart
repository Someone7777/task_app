import 'package:fpdart/fpdart.dart';
import 'package:task_app/config/local_db_client.dart';
import 'package:task_app/src/core/domain/failures/empty_failure.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/core/domain/failures/no_local_entity_failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';

class TaskLocalDataSource {
  final LocalDbClient localDbClient;

  static const tableName = "task";

  /// Default constructor
  TaskLocalDataSource({required this.localDbClient});

  Future<Either<Failure, TaskEntity>> get(BigInt id) async {
    try {
      final jsonObj =
          await localDbClient.getById(tableName: tableName, id: id.toString());
      if (jsonObj == null) {
        return left(
            const NoLocalEntityFailure(entityName: tableName, detail: ""));
      }
      return right(TaskEntity.fromJson(jsonObj));
    } on Exception {
      return left(
          const NoLocalEntityFailure(entityName: tableName, detail: ""));
    }
  }

  Future<Either<Failure, void>> put(TaskEntity task) async {
    try {
      await localDbClient.putById(
          tableName: tableName, id: task.id.toString(), content: task.toJson());
      return right(null);
    } on Exception {
      return left(const EmptyFailure());
    }
  }

  Future<Either<Failure, void>> delete(BigInt id) async {
    try {
      await localDbClient.deleteById(id: id.toString(), tableName: tableName);
      return right(null);
    } on Exception {
      return left(const EmptyFailure());
    }
  }
}
