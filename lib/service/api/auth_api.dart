import 'package:dio/dio.dart';
import 'package:montrack/models/auth/auth_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_api.g.dart';

typedef LoginPayload = ({String email, String password});
typedef SignUpPayload = ({String name, String email, String password});

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<void> build() {}

  Future<AuthLoginResponse> signIn(LoginPayload payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post(
          '/auth/signin',
          data: {"email": payload.email, "password": payload.password},
        );

    return AuthLoginResponse.fromJson(response.data);
  }

  Future<AuthSignUpResponse> signUp(SignUpPayload payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post(
          '/auth/signup',
          data: {
            "name": payload.name,
            "email": payload.email,
            "password": payload.password,
          },
        );

    return AuthSignUpResponse.fromJson(response.data);
  }

  Future handleRefreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final storage = ref.watch(secureStorageProvider);
    final refreshTokenKey = await storage.get('refresh_token');

    if (err.response?.statusCode == 401 && refreshTokenKey != null) {
      logger.i('Token has invalid, trying to request new token');

      final networkService = ref.watch(networkServiceProvider);

      try {
        final response = await networkService.post(
          '/auth/refresh-token',
          data: {"refresh_token": refreshTokenKey},
        );

        final resData = RefreshTokenResponse.fromJson(response.data);

        if (response.statusCode == 200) {
          logger.i('Success create new token');

          final newAccessToken = resData.data.accessToken;
          final newRefreshToken = resData.data.refreshToken;
          final options = err.requestOptions;

          // Set new headers Authorization
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          // Store new token to Secure storage
          storage.write('access_token', newAccessToken);
          storage.write('refresh_token', newRefreshToken);

          // Re-call request with new token
          return handler.resolve(await networkService.fetch(options));
        }
      } on DioException catch (error) {
        logger.e(
          'Error on create access token',
          error: error,
          stackTrace: error.stackTrace,
        );

        // Delete token when refresh token is error / fail
        await storage.delete('access_token');
        await storage.delete('refresh_token');

        // Continue process with error rejection
        return handler.next(error);
      }
    }
  }
}
