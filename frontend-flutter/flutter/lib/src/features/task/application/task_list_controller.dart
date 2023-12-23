import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/src/core/domain/failures/api_bad_request_failure.dart';
import 'package:task_app/src/core/domain/failures/http_connection_failure.dart';
import 'package:task_app/src/core/domain/failures/no_local_entity_failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';
import 'package:task_app/src/features/task/domain/repositories/task_repository_interface.dart';

class TaskListController extends StateNotifier<AsyncValue<List<TaskEntity>>> {
  final TaskRepositoryInterface repository;

  TaskListController({required this.repository})
      : super(const AsyncValue.loading()) {
    getTasks(1);
  }

  Future<void> getTasks(final int page) async {
    final res = await repository.getTasks(page);
    state = res.fold((failure) {
      if (failure is HttpConnectionFailure ||
          failure is NoLocalEntityFailure ||
          failure is ApiBadRequestFailure) {
        return AsyncError(failure, StackTrace.current);
      }
      return AsyncValue.error(failure.detail, StackTrace.empty);
    }, (entities) {
      return AsyncValue.data(entities);
    });
  }

  /// Add an entity to list
  void add(TaskEntity entity) {
    // No need to use repository,
    // it will be used by Create Controller
    if (state.value != null) {
      final entities = state.value!;
      entities.add(entity);
      state = AsyncValue.data(entities);
    } else {
      state = AsyncValue.data([entity]);
    }
  }

  /// Update an entity of the list
  void update(TaskEntity entity) {
    // No need to use repository,
    // it will be used by Edit Controller
    if (state.value != null) {
      final entities = state.value!;
      final i = entities.indexWhere((element) => element.id == entity.id);
      if (i != -1) {
        entities
          ..removeAt(i)
          ..insert(i, entity);
      }
      state = AsyncValue.data(entities);
    } else {
      state = AsyncValue.data([entity]);
    }
  }

  /// Delete an entity of the list
  void delete(TaskEntity entity) {
    if (state.value != null) {
      final entities = state.value!;
      entities.remove(entity);
      repository.deleteTask(entity);
      state = AsyncValue.data(entities);
    }
  }
}
