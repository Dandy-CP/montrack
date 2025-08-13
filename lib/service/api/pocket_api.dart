import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/pocket/pocket_detail_model.dart';
import 'package:montrack/models/pocket/pocket_list_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_api.g.dart';

typedef CreatePocketPayload = ({
  String pocketName,
  String pocketEmoji,
  int pocketAmount,
  String pocketDescription,
});

@Riverpod(keepAlive: true)
Future<PocketListResponse> getListPocket(
  Ref ref, {
  int? page,
  int? limit,
}) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get(
        '/pocket/list',
        queryParameters: {'page': page ?? 1, 'limit': limit ?? 10},
      );

  return PocketListResponse.fromJson(response.data);
}

@riverpod
Future<PocketDetailResponse> getPocketDetail(Ref ref, String pocketId) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get('/pocket/detail', queryParameters: {"pocket_id": pocketId});

  return PocketDetailResponse.fromJson(response.data);
}

@riverpod
class PocketRequest extends _$PocketRequest {
  @override
  FutureOr<void> build() {}

  Future<String?> createPocket(CreatePocketPayload payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post(
          '/pocket/create',
          data: {
            "pocket_name": payload.pocketName,
            "pocket_emoji": payload.pocketEmoji,
            "pocket_amount": payload.pocketAmount,
            "pocket_description": payload.pocketDescription,
          },
        );

    if (response.statusCode == 201) {
      return 'Success create pocket';
    }

    return null;
  }

  Future<Response<dynamic>> updatePocket({
    required String pocketId,
    required CreatePocketPayload payload,
  }) async {
    final response = await ref
        .watch(networkServiceProvider)
        .put(
          '/pocket/update',
          queryParameters: {"pocket_id": pocketId},
          data: {
            "pocket_name": payload.pocketName,
            "pocket_emoji": payload.pocketEmoji,
            "pocket_amount": payload.pocketAmount,
            "pocket_description": payload.pocketDescription,
          },
        );

    return response;
  }

  Future<String?> deletePocket(String pocketId) async {
    final response = await ref
        .watch(networkServiceProvider)
        .delete('/pocket/delete', queryParameters: {"pocket_id": pocketId});

    if (response.statusCode == 200) {
      return 'Success delete pocket';
    }

    return null;
  }
}
