import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/meta_model.dart';
import 'package:montrack/models/transaction/transaction_model.dart';

part 'goals_list_model.freezed.dart';
part 'goals_list_model.g.dart';

@freezed
abstract class GoalsListResponse with _$GoalsListResponse {
  const factory GoalsListResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required List<GoalsListData> data,
    @JsonKey(name: "meta") required Meta meta,
  }) = _GoalsListResponse;

  factory GoalsListResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalsListResponseFromJson(json);
}

@freezed
abstract class GoalsListData with _$GoalsListData {
  const factory GoalsListData({
    @JsonKey(name: "goals_id") required String goalsId,
    @JsonKey(name: "goals_name") required String goalsName,
    @JsonKey(name: "goals_description") required String goalsDescription,
    @JsonKey(name: "goals_set_amount") required int goalsSetAmount,
    @JsonKey(name: "goals_amount") required int goalsAmount,
    @JsonKey(name: "goals_attachment") required String goalsAttachment,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "goals_history")
    required List<TransactionListData> goalsHistory,
    @JsonKey(name: "wallet_owner") required WalletOwner walletOwner,
  }) = _GoalsListData;

  factory GoalsListData.fromJson(Map<String, dynamic> json) =>
      _$GoalsListDataFromJson(json);
}

@freezed
abstract class WalletOwner with _$WalletOwner {
  const factory WalletOwner({
    @JsonKey(name: "wallet_id") required String walletId,
    @JsonKey(name: "wallet_name") required String walletName,
    @JsonKey(name: "wallet_amount") required int walletAmount,
    @JsonKey(name: "is_wallet_active") required bool isWalletActive,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
  }) = _WalletOwner;

  factory WalletOwner.fromJson(Map<String, dynamic> json) =>
      _$WalletOwnerFromJson(json);
}
