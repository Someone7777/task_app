import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/core/domain/failures/unprocessable_entity_failure.dart';
import 'package:task_app/src/features/task/domain/entities/task_entity.dart';
import 'package:task_app/src/features/task/domain/repositories/task_repository_interface.dart';
import 'package:task_app/src/features/task/domain/values/task_description_value.dart';
import 'package:task_app/src/features/task/domain/values/task_title_value.dart';

class TaskCreateController extends StateNotifier<AsyncValue<void>> {
  final TaskRepositoryInterface repository;

  TaskCreateController({required this.repository})
      : super(const AsyncValue.data(null));

  Future<Either<Failure, TaskEntity>> handle(
      TaskTitleValue title,
      TaskDescriptionValue description,
      DateTime finishedDate,
      DateTime deadlineDate,
      AppLocalizations appLocalizations) async {
    state = const AsyncValue.loading();
    return await title.value.fold((failure) {
      state = const AsyncValue.data(null);
      return left(failure);
    }, (title) async {
      return await description.value.fold((failure) {
        state = const AsyncValue.data(null);
        return left(failure);
      }, (description) async {
        final res = await repository.createTask(TaskEntity(
            title: title,
            description: description,
            finished: finishedDate,
            deadline: deadlineDate));
        return res.fold((failure) {
          state = const AsyncValue.data(null);
          return left(
              InvalidValueFailure(detail: appLocalizations.genericError));
        }, (value) {
          state = const AsyncValue.data(null);
          return right(value);
        });
      });
    });
  }
}
