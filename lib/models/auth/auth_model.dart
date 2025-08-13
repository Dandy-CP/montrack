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

@freezed
abstract class GetLoggedInUserResponse with _$GetLoggedInUserResponse {
  const factory GetLoggedInUserResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required GetLoggedInUserData data,
  }) = _GetLoggedInUserResponse;

  factory GetLoggedInUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLoggedInUserResponseFromJson(json);
}

@freezed
abstract class GetLoggedInUserData with _$GetLoggedInUserData {
  const factory GetLoggedInUserData({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: 'is_2fa_active') required bool is2FAActive,
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "refresh_token") required String refreshToken,
  }) = _GetLoggedInUserData;

  factory GetLoggedInUserData.fromJson(Map<String, dynamic> json) =>
      _$GetLoggedInUserDataFromJson(json);
}

@freezed
abstract class Enable2FAResponse with _$Enable2FAResponse {
  const factory Enable2FAResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required Enabled2FAData data,
  }) = _Enable2FAResponse;

  factory Enable2FAResponse.fromJson(Map<String, dynamic> json) =>
      _$Enable2FAResponseFromJson(json);
}

@freezed
abstract class Enabled2FAData with _$Enabled2FAData {
  const factory Enabled2FAData({
    @JsonKey(name: "qrCode") required String qrCode,
    @JsonKey(name: 'secret') required String secret,
  }) = _Enabled2FAData;

  factory Enabled2FAData.fromJson(Map<String, dynamic> json) =>
      _$Enabled2FADataFromJson(json);
}
