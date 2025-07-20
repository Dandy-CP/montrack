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
