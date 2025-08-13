import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/meta_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionListResponse with _$TransactionListResponse {
  const factory TransactionListResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required List<TransactionListData> data,
    @JsonKey(name: "meta") required Meta meta,
  }) = _TransactionListResponse;

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionListResponseFromJson(json);
}

@freezed
abstract class TransactionListData with _$TransactionListData {
  const factory TransactionListData({
    @JsonKey(name: "transaction_id") required String transactionId,
    @JsonKey(name: "transaction_name") required String transactionName,
    @JsonKey(name: "transaction_ammount") required int transactionAmmount,
    @JsonKey(name: "transaction_type") required String transactionType,
    @JsonKey(name: "transaction_from") required String transactionFrom,
    @JsonKey(name: "transaction_attachment")
    required String transactionAttachment,
    @JsonKey(name: "transaction_description") String? transactionDescription,
    @JsonKey(name: "transaction_date") required String transactionDate,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "goals_history_id") required dynamic goalsHistoryId,
    @JsonKey(name: "pocket_history_id") required String? pocketHistoryId,
  }) = _TransactionListData;

  factory TransactionListData.fromJson(Map<String, dynamic> json) =>
      _$TransactionListDataFromJson(json);
}

@freezed
abstract class TransactionSummaryResponse with _$TransactionSummaryResponse {
  const factory TransactionSummaryResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required SummaryData data,
  }) = _TransactionSummaryResponse;

  factory TransactionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryResponseFromJson(json);
}

@freezed
abstract class SummaryData with _$SummaryData {
  const factory SummaryData({
    @JsonKey(name: "income") required int income,
    @JsonKey(name: "expense") required int expense,
  }) = _SummaryData;

  factory SummaryData.fromJson(Map<String, dynamic> json) =>
      _$SummaryDataFromJson(json);
}

@freezed
abstract class TransactionQuery with _$TransactionQuery {
  const factory TransactionQuery({
    String? transactionType,
    String? transactionFrom,
    String? startDate,
    String? endDate,
  }) = _TransactionQuery;

  factory TransactionQuery.empty() => const TransactionQuery();
}
