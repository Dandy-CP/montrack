import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_model.freezed.dart';
part 'response_model.g.dart';

@freezed
class ResponseResult<T> with _$ResponseResult<T> {
  const factory ResponseResult.success(T response) = _success;

  const factory ResponseResult.error(ResponseError error) = _error;

  const factory ResponseResult.unknownError(String message) = _UnknownError;
}

@freezed
abstract class ResponseError with _$ResponseError {
  const factory ResponseError({required int status, required String message}) =
      _ResponseError;

  factory ResponseError.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorFromJson(json);
}
