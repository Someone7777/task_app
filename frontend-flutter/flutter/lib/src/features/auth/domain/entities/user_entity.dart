import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// [UserEntity] model
@freezed
class UserEntity with _$UserEntity {
  /// Factory constructor
  /// [username] - [String] username
  /// [full_name] - [String] full name
  /// [email] - [String] email
  /// [language] - [double] language
  /// [image] - [double] profile image
  /// [lastLogin] - [DateTime] last login date
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserEntity({
    required String username,
    required String fullName,
    required String email,
    required String language,
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) required String? image,
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) required DateTime? lastLogin,
  }) = _UserEntity;

  // Serialization
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
