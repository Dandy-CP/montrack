import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/config/router.dart';
import 'package:montrack/models/auth/auth_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/providers/storage/shared_prefs_provider.dart';
import 'package:montrack/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_api.g.dart';

typedef LoginPayload = ({String email, String password});
typedef SignUpPayload = ({String name, String email, String password});

@riverpod
Future<void> initialStartUp(Ref ref) async {
  final tokenValue = await ref.watch(secureStorageProvider).get('access_token');
  final pinValue = await ref.watch(secureStorageProvider).get('user-pin');

  final response = await ref
      .watch(networkServiceProvider)
      .get('/auth/logedin-user');

  if (response.statusCode == 200 && tokenValue != null && pinValue == null) {
    router.replace('/home');
    return;
  }

  if (response.statusCode == 200 && tokenValue != null && pinValue != null) {
    router.replace(
      Uri(
        path: '/input-pin',
        queryParameters: {'title': 'Please input your pin', 'type': 'input'},
      ).toString(),
    );
    return;
  }
}

@Riverpod(keepAlive: true)
Future<String?> getUserPinStorage(Ref ref) async {
  final storage = ref.watch(secureStorageProvider);
  final pin = await storage.get('user-pin');

  return pin;
}

@riverpod
Future<GetLoggedInUserResponse> getLoggedUser(Ref ref) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get('/auth/logedin-user');

  return GetLoggedInUserResponse.fromJson(response.data);
}

@riverpod
Future<Enable2FAResponse> enable2FA(Ref ref) async {
  final response = await ref
      .watch(networkServiceProvider)
      .post('/auth/enable-2fa');

  return Enable2FAResponse.fromJson(response.data);
}

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<void> build() {}

  Future<Response<dynamic>> signIn(LoginPayload payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post(
          '/auth/signin',
          data: {"email": payload.email, "password": payload.password},
        );

    return response;
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

  Future<String?> signOut() async {
    final storage = ref.watch(secureStorageProvider);
    final response = await ref
        .watch(networkServiceProvider)
        .post('/auth/logout');

    if (response.statusCode == 201) {
      await storage.delete('access_token');
      await storage.delete('refresh_token');
      await storage.delete('user-pin');

      return 'Success logout';
    }

    return null;
  }

  Future<Response<dynamic>> validate2FA({
    required Map<String, dynamic> payload,
  }) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post('/auth/validate-2fa', data: payload);

    return response;
  }

  Future<Response<dynamic>> verify2FA({
    required Map<String, dynamic> payload,
  }) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post('/auth/verify-new-2fa', data: payload);

    return response;
  }

  Future<Response<dynamic>> disabled2FA({
    required Map<String, dynamic> payload,
  }) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post('/auth/disable-2fa', data: payload);

    return response;
  }

  Future<Response<dynamic>> resetAccount() async {
    final response = await ref
        .watch(networkServiceProvider)
        .post('/auth/reset-account');

    return response;
  }

  Future<Response<dynamic>> deleteAccount() async {
    final storage = ref.watch(secureStorageProvider);
    final response = await ref
        .watch(networkServiceProvider)
        .post('/auth/delete-account');

    if (response.statusCode == 201) {
      await storage.delete('access_token');
      await storage.delete('refresh_token');
      await storage.delete('user-pin');
    }

    return response;
  }

  Future handleRefreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final storage = ref.watch(secureStorageProvider);
    final refreshTokenKey = await storage.get('refresh_token');

    final sharedPrefs = ref.watch(sharedPrefsProvider);
    final isHasOnboarding = await sharedPrefs.getBool('hasOnBoarding');

    if (err.response?.statusCode == 401 && refreshTokenKey != null) {
      logger.i('Token has invalid, trying to request new token');

      final networkService = ref.watch(networkServiceProvider);

      try {
        final response = await networkService.post(
          '/auth/refresh-token',
          data: {"refresh_token": refreshTokenKey},
        );

        final resData = RefreshTokenResponse.fromJson(response.data);

        if (response.statusCode == 201) {
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

        // replace screen to login
        router.go('/login');

        // Continue process with error rejection
        return handler.next(error);
      }
    } else if (refreshTokenKey == null) {
      if (isHasOnboarding != null && isHasOnboarding) {
        router.replace('/login');
      } else {
        router.replace('/onboarding');
      }
    }
  }
}
