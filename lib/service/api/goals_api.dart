import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/goals/goals_detail_model.dart';
import 'package:montrack/models/goals/goals_list_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goals_api.g.dart';

@Riverpod(keepAlive: true)
Future<GoalsListResponse> getListGoals(Ref ref, {int? page, int? limit}) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get(
        '/goals/list',
        queryParameters: {'page': page ?? 1, 'limit': limit ?? 10},
      );

  return GoalsListResponse.fromJson(response.data);
}

@riverpod
Future<GoalsDetailResponse> getGoalsDetail(
  Ref ref, {
  required String goalsId,
}) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get('/goals/detail', queryParameters: {'goals_id': goalsId});

  return GoalsDetailResponse.fromJson(response.data);
}

@riverpod
class GoalsRequest extends _$GoalsRequest {
  @override
  FutureOr<void> build() {}

  Future<Response<dynamic>> createGoals({required FormData payload}) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post(
          '/goals/create',
          data: payload,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        );

    return response;
  }

  Future<Response<dynamic>> updateGoals({
    required String goalsId,
    required FormData payload,
  }) async {
    final response = await ref
        .watch(networkServiceProvider)
        .put(
          '/goals/update',
          queryParameters: {"goals_id": goalsId},
          data: payload,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        );

    return response;
  }

  Future<Response<dynamic>> deleteGoals({required String goalsId}) async {
    final response = await ref
        .watch(networkServiceProvider)
        .delete('/goals/delete', queryParameters: {"goals_id": goalsId});

    return response;
  }
}
