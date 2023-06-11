import 'package:fpdart/fpdart.dart';
import 'package:task_app/src/core/domain/failures/failure.dart';
import 'package:task_app/src/features/auth/domain/entities/reset_password_entity.dart';

/// Forgot Password Repository Interface.
abstract class ResetPasswordRepositoryInterface {
  /// Request forgot password code by `email`.
  Future<Either<Failure, void>> requestCode(String email);

  /// Request forgot password code verification.
  Future<Either<Failure, void>> verifyCode(ResetPasswordEntity entity);
}