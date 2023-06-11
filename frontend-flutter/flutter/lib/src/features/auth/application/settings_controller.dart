import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/core/domain/failures/unprocessable_entity_failure.dart';
import 'package:task_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:task_app/src/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:task_app/src/features/auth/domain/repositories/settings_repository_interface.dart';

class SettingsController extends StateNotifier<AsyncValue<void>> {
  @visibleForTesting
  final AuthRepositoryInterface authRepository;
  @visibleForTesting
  final SettingsRepositoryInterface settingsRepository;

  SettingsController(
      {required this.authRepository, required this.settingsRepository})
      : super(const AsyncValue.data(null));

  Future<Either<Failure, UserEntity>> handleLanguage(UserEntity user,
      Locale lang, AppLocalizations appLocalizations) async {
    state = const AsyncValue.loading();
    final res = await authRepository.updateUser(
      UserEntity(
          username: user.username,
          fullName: user.fullName,
          email: user.email,
          language: lang.languageCode,
          lastLogin: null,
          image: null),
    );
    return res.fold((_) {
      state = const AsyncValue.data(null);
      return left(
          UnprocessableEntityFailure(detail: appLocalizations.genericError));
    }, (value) {
      state = const AsyncValue.data(null);
      return right(value);
    });
  }

  Future<Either<Failure, UserEntity>> handleReceiveEmailBalance(
      UserEntity user,
      bool receiveEmailBalance,
      AppLocalizations appLocalizations) async {
    state = const AsyncValue.loading();
    final res = await authRepository.updateUser(
      UserEntity(
          username: user.username,
          fullName: user.fullName,
          email: user.email,
          language: user.language,
          lastLogin: null,
          image: null),
    );
    return res.fold((_) {
      state = const AsyncValue.data(null);
      return left(
          UnprocessableEntityFailure(detail: appLocalizations.genericError));
    }, (value) {
      state = const AsyncValue.data(null);
      return right(value);
    });
  }

  Future<Either<Failure, bool>> handleThemeMode(
      ThemeData theme, AppLocalizations appLocalizations) async {
    state = const AsyncValue.loading();
    final res = await settingsRepository.saveTheme(theme);
    return res.fold((_) {
      state = const AsyncValue.data(null);
      return left(
          UnprocessableEntityFailure(detail: appLocalizations.genericError));
    }, (value) {
      state = const AsyncValue.data(null);
      return right(value);
    });
  }
}
