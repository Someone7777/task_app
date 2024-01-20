import 'package:fpdart/fpdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/core/domain/failures/unprocessable_entity_failure.dart';
import 'package:task_app/src/core/domain/values/value_abstract.dart';

class TaskDescriptionValue extends ValueAbstract<String> {
  @override
  Either<Failure, String> get value => _value;
  final Either<Failure, String> _value;

  factory TaskDescriptionValue(
      AppLocalizations appLocalizations, String input) {
    return TaskDescriptionValue._(
      _validate(appLocalizations, input),
    );
  }

  const TaskDescriptionValue._(this._value);
}

Either<Failure, String> _validate(
    AppLocalizations appLocalizations, String input) {
  if (input.isNotEmpty && input.length <= 300) {
    return right(input);
  }
  final String message = input.isEmpty
      ? appLocalizations.taskDescriptionRequired
      : appLocalizations.taskDescriptionMaxLength;
  return left(
    InvalidValueFailure(
      detail: message,
    ),
  );
}
