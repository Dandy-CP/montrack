import 'package:dio/dio.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/utils/logger.dart';

final class NetworkInterceptor extends Interceptor {
  final ISecureStorage _flutterSecureStorage;
  final Auth _authRequest;

  NetworkInterceptor(this._flutterSecureStorage, this._authRequest);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logger.i(
      'REQUEST[${options.method}] => PATH: ${options.path} QUERY: ${options.queryParameters}',
    );

    final accessTokenKey = await _flutterSecureStorage.get('access_token');

    if (accessTokenKey != null) {
      // Set header config each request
      options.headers['Authorization'] = 'Bearer $accessTokenKey';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} QUERY: ${response.requestOptions.queryParameters}',
    );

    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} QUERY: ${err.requestOptions.queryParameters}',
      error: err.response?.data ?? err.message,
    );

    await _authRequest.handleRefreshToken(err, handler);

    super.onError(err, handler);
  }
}
