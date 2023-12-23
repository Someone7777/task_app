import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

/// [TaskEntity] model
@freezed
class TaskEntity with _$TaskEntity {
  /// Factory constructor
  /// [id] - [int] id
  /// [title] - [String] title
  /// [description] - [String] description
  /// [created] - [DateTime] created
  /// [finished] - [DateTime] finished
  /// [deadline] - [DateTime] deadline
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TaskEntity({
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) required int? id,
    required String title,
    required String description,
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) required DateTime? created,
    required DateTime? finished,
    required DateTime deadline,
  }) = _TaskEntity;

  // Serialization
  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);
}
