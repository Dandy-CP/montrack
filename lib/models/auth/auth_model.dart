import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AuthLoginResponse with _$AuthLoginResponse {
  const factory AuthLoginResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required AuthLoginData data,
  }) = _AuthLoginResponse;

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginResponseFromJson(json);
}

@freezed
abstract class AuthLoginData with _$AuthLoginData {
  const factory AuthLoginData({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "refresh_token") required String refreshToken,
  }) = _AuthLoginData;

  factory AuthLoginData.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginDataFromJson(json);
}

@freezed
abstract class AuthSignUpResponse with _$AuthSignUpResponse {
  const factory AuthSignUpResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required AuthSignUpData data,
  }) = _AuthSignUpResponse;

  factory AuthSignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSignUpResponseFromJson(json);
}

@freezed
abstract class AuthSignUpData with _$AuthSignUpData {
  const factory AuthSignUpData({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
  }) = _AuthSignUpData;

  factory AuthSignUpData.fromJson(Map<String, dynamic> json) =>
      _$AuthSignUpDataFromJson(json);
}

@freezed
abstract class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required RefreshTokenData data,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

@freezed
abstract class RefreshTokenData with _$RefreshTokenData {
  const factory RefreshTokenData({
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "refresh_token") required String refreshToken,
  }) = _RefreshTokenData;

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataFromJson(json);
}
