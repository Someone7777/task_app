import 'package:fpdart/fpdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/core/domain/failures/unprocessable_entity_failure.dart';
import 'package:task_app/src/core/domain/values/value_abstract.dart';

/// User Name value
class UserName extends ValueAbstract<String> {
  @override
  Either<Failure, String> get value => _value;
  final Either<Failure, String> _value;

  factory UserName(AppLocalizations appLocalizations, String input) {
    return UserName._(
      _validate(appLocalizations, input),
    );
  }

  const UserName._(this._value);
}

/// * minLength: 1
/// * maxLength: 15
/// * only alphanumeric characters
Either<Failure, String> _validate(
    AppLocalizations appLocalizations, String input) {
  if (input.isNotEmpty &&
      input.length <= 10 &&
      RegExp(r"^[A-Za-z0-9]+$").hasMatch(input)) {
    return right(input);
  }
  String message = input.isEmpty
      ? appLocalizations.needUsername
      : input.length > 10
          ? appLocalizations.usernameMaxSize
          : appLocalizations.usernameNotValid;
  return left(
    UnprocessableEntityFailure(
      detail: message,
    ),
  );
}