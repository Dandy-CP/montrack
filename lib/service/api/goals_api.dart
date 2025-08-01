import 'package:flutter_riverpod/flutter_riverpod.dart';
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
