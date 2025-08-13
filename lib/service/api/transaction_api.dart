import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:montrack/models/transaction/transaction_model.dart';
import 'package:montrack/providers/network/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_api.g.dart';

@riverpod
class TransactionListRequest extends _$TransactionListRequest {
  static final int _defaultPage = 1;
  static final int _defaultLimit = 10;
  static bool _isLoadingNextPage = false;

  @override
  Future<TransactionListResponse> build({TransactionQuery? query}) async {
    // Call the initial request for initial data value
    return _getTransaction(
      page: _defaultPage,
      limit: _defaultLimit,
      query: query ?? TransactionQuery.empty(),
    );
  }

  // declare private function to fetch data
  Future<TransactionListResponse> _getTransaction({
    int? page,
    int? limit,
    required TransactionQuery query,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'limit': limit,
      if (query.transactionType != null)
        'transactionType': query.transactionType,
      if (query.transactionFrom != null)
        'transactionFrom': query.transactionFrom,
      if (query.startDate != null) 'startDate': query.startDate,
      if (query.endDate != null) 'endDate': query.endDate,
    };

    final response = await ref
        .watch(networkServiceProvider)
        .get('/transaction/list', queryParameters: queryParameters);

    return TransactionListResponse.fromJson(response.data);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNextPage) return;
    if (state.value?.meta.isLastPage == true) return;

    final nextPage = (state.value?.meta.currentPage ?? 0) + 1;
    _isLoadingNextPage = true;

    // Call the next page request
    final newItems = await _getTransaction(
      page: nextPage,
      limit: _defaultLimit,
      query: query ?? TransactionQuery.empty(),
    );

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
class TransactionRequest extends _$TransactionRequest {
  @override
  FutureOr<void> build() {}

  Future<Response<dynamic>> createTransaction(FormData payload) async {
    final response = await ref
        .watch(networkServiceProvider)
        .post(
          '/transaction/create',
          data: payload,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        );

    return response;
  }
}

@riverpod
Future<TransactionSummaryResponse> getSummaryTransaction(Ref ref) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get('/transaction/summary');

  return TransactionSummaryResponse.fromJson(response.data);
}

@riverpod
Future<TransactionSummaryResponse> getTransactionSummary(
  Ref ref, {
  String? startDate,
  String? endDate,
}) async {
  final response = await ref
      .watch(networkServiceProvider)
      .get(
        '/transaction/summary',
        queryParameters: {
          if (startDate != null) 'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
        },
      );

  return TransactionSummaryResponse.fromJson(response.data);
}
