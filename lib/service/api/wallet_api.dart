import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/wallet/active_wallet_model.dart';
import 'package:montrack/models/wallet/wallet_list_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_api.g.dart';

@Riverpod(keepAlive: true)
Future<ActiveWalletResponse> getActiveWallet(Ref ref) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get('/wallet/active');

  return ActiveWalletResponse.fromJson(response.data);
}

@riverpod
class WalletList extends _$WalletList {
  static final int _defaultPage = 1;
  static final int _defaultLimit = 10;
  static bool _isLoadingNextPage = false;

  @override
  Future<WalletListResponse> build({int? page, int? limit}) async {
    // Call the initial request for initial data value
    return _getWallet(page: _defaultPage, limit: _defaultLimit);
  }

  // declare private function to fetch data
  Future<WalletListResponse> _getWallet({int? page, int? limit}) async {
    final response = await ref
        .watch(networkServiceProvider)
        .get(
          '/wallet/list',
          queryParameters: {"page": page ?? 1, "limit": limit ?? 10},
        );

    return WalletListResponse.fromJson(response.data);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNextPage) return;
    if (state.value?.meta.isLastPage == true) return;

    final nextPage = (state.value?.meta.currentPage ?? 0) + 1;
    _isLoadingNextPage = true;

    // Call the next page request
    final newItems = await _getWallet(page: nextPage, limit: _defaultLimit);

    // Update the state with the new data
    state = AsyncValue.data(
      state.value!.copyWith(
        data: [...state.value!.data, ...newItems.data],
        meta: newItems.meta,
      ),
    );
  }
}

@riverpod
class WalletRequest extends _$WalletRequest {
  @override
  FutureOr<void> build() {}

  Future<Response<dynamic>> useWallet(Map<String, dynamic> payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .put(
          '/wallet/status',
          queryParameters: {'wallet_id': payload['walletId']},
          data: payload,
        );

    return response;
  }

  Future<Response<dynamic>> createWallet(Map<String, dynamic> payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post('/wallet/create', data: payload);

    return response;
  }

  Future<Response<dynamic>> editWallet(Map<String, dynamic> payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .put(
          '/wallet/update',
          queryParameters: {'wallet_id': payload['walletId']},
          data: payload,
        );

    return response;
  }

  Future<Response<dynamic>> deleteWallet(Map<String, dynamic> payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .delete(
          '/wallet/delete',
          queryParameters: {'wallet_id': payload['walletId']},
        );

    return response;
  }
}
