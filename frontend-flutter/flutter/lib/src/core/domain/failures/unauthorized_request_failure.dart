import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_app/src/core/domain/failures/http_request_failure.dart';

part 'unauthorized_request_failure.g.dart';

/// Represent 401 request error
@JsonSerializable(fieldRename: FieldRename.snake)
class UnauthorizedRequestFailure extends HttpRequestFailure {
  const UnauthorizedRequestFailure({super.detail = ""})
      : super(statusCode: 401);

  // Serialization
  factory UnauthorizedRequestFailure.fromJson(Map<String, dynamic> json) =>
      _$UnauthorizedRequestFailureFromJson(json);
}