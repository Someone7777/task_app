import 'package:fpdart/fpdart.dart';
import 'package:task_app/config/api_client.dart';
import 'package:task_app/config/api_contract.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';

class TaskRemoteDataSource {
  final ApiClient apiClient;

  /// Default constructor
  TaskRemoteDataSource({required this.apiClient});

  Future<Either<Failure, void>> create(TaskEntity task) async {
    final response =
        await apiClient.postRequest(APIContract.task, data: task.toJson());
    // Check if there is a request failure
    return response.fold((failure) => left(failure), (_) => right(null));
  }

  Future<Either<Failure, TaskEntity>> update(TaskEntity task) async {
    final response = await apiClient
        .patchRequest("${APIContract.task}/${task.id}", data: task.toJson());
    // Check if there is a request failure
    return response.fold((failure) => left(failure),
        (value) => right(TaskEntity.fromJson(value.data)));
  }

  Future<Either<Failure, TaskEntity>> get(BigInt id) async {
    final response = await apiClient.getRequest("${APIContract.task}/$id");
    // Check if there is a request failure
    return response.fold((failure) => left(failure),
        (value) => right(TaskEntity.fromJson(value.data)));
  }

  Future<Either<Failure, void>> delete(BigInt id) async {
    final response = await apiClient.delRequest("${APIContract.task}/$id");
    // Check if there is a request failure
    return response.fold((failure) => left(failure), (_) => right(null));
  }
}
