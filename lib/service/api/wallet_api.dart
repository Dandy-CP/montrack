import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/wallet/active_wallet_model.dart';
import 'package:montrack/models/wallet/wallet_list_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_api.g.dart';

typedef QParams = ({int page, int limit});

@Riverpod(keepAlive: true)
Future<ActiveWalletResponse> getActiveWallet(Ref ref) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get('/wallet/active');

  return ActiveWalletResponse.fromJson(response.data);
}

@Riverpod(keepAlive: true)
Future<WalletListResponse> getWalletList(Ref ref, QParams query) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get(
        '/wallet/list',
        queryParameters: {"page": query.page, "limit": query.limit},
      );

  return WalletListResponse.fromJson(response.data);
}
