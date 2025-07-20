import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/providers/network/network_interceptor.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@Riverpod(keepAlive: true)
Dio networkService(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://montrack-service.vercel.app',
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
      sendTimeout: Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
      },
    ),
  );

  final networkInterceptor = ref.watch(networkServiceInterceptorProvider);

  dio.interceptors.addAll([networkInterceptor]);

  return dio;
}

@riverpod
NetworkInterceptor networkServiceInterceptor(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  final authRequest = ref.read(authProvider.notifier);

  return NetworkInterceptor(storage, authRequest);
}
