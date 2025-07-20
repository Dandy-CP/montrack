import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_api.g.dart';

typedef QParams = ({int page, int limit});

@Riverpod(keepAlive: true)
Future<TransactionListResponse> getTransactionList(
  Ref ref,
  QParams query,
) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get(
        '/transaction/list',
        queryParameters: {'page': query.page, 'limit': query.limit},
      );

  return TransactionListResponse.fromJson(response.data);
}
