import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/pocket/pocket_list_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocket_api.g.dart';

typedef QParams = ({int page, int limit});

@Riverpod(keepAlive: true)
Future<PocketListResponse> getListPocket(Ref ref, QParams query) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get(
        '/pocket/list',
        queryParameters: {'page': query.page, 'limit': query.limit},
      );

  return PocketListResponse.fromJson(response.data);
}
