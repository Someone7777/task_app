import 'package:fpdart/fpdart.dart';
import 'package:task_app/config/api_client.dart';
import 'package:task_app/config/api_contract.dart';
import 'package:task_app/src/core/domain/entities/pagination_entity.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';

class TaskRemoteDataSource {
  final ApiClient apiClient;

  /// Default constructor
  TaskRemoteDataSource({required this.apiClient});

  Future<Either<Failure, TaskEntity>> create(TaskEntity task) async {
    final response =
        await apiClient.postRequest(APIContract.task, data: task.toJson());
    // Check if there is a request failure
    return response.fold((failure) => left(failure),
        (value) => right(TaskEntity.fromJson(value.data)));
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

  Future<Either<Failure, void>> delete(int id) async {
    final response = await apiClient.delRequest("${APIContract.task}/$id");
    // Check if there is a request failure
    return response.fold((failure) => left(failure), (_) => right(null));
  }

  Future<Either<Failure, List<TaskEntity>>> list({required int page}) async {
    final Map<String, dynamic> queryParameters = {
      "page": page,
    };
    final response = await apiClient.getRequest(APIContract.task,
        queryParameters: queryParameters);
    // Check if there is a request failure
    return await response.fold((failure) => left(failure), (value) async {
      final PaginationEntity page = PaginationEntity.fromJson(value.data);
      return right(page.results.map((balance) {
        return TaskEntity.fromJson(balance);
      }).toList());
    });
  }
}
