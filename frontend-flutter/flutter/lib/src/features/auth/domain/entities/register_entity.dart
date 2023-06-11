import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_entity.freezed.dart';
part 'register_entity.g.dart';

/// [RegisterEntity] model
@freezed
class RegisterEntity with _$RegisterEntity {
  /// Factory constructor
  /// [username] - [String] username
  /// [email] - [String] email
  /// [fullName] - [String] full name
  /// [language] - [String] language
  /// [password] - [String] password
  /// [password2] - [String] scond password
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RegisterEntity({
    required String username,
    required String email,
    required String fullName,
    required String language,
    required String password,
    required String password2,
  }) = _RegisterEntity;

  // Serialization
  factory RegisterEntity.fromJson(Map<String, dynamic> json) =>
      _$RegisterEntityFromJson(json);
}