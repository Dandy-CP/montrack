import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/meta_model.dart';
import 'package:montrack/models/transaction/transaction_model.dart';

part 'pocket_list_model.freezed.dart';
part 'pocket_list_model.g.dart';

@freezed
abstract class PocketListResponse with _$PocketListResponse {
  const factory PocketListResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required List<ListPocketData> data,
    @JsonKey(name: "meta") required Meta meta,
  }) = _PocketListResponse;

  factory PocketListResponse.fromJson(Map<String, dynamic> json) =>
      _$PocketListResponseFromJson(json);
}

@freezed
abstract class ListPocketData with _$ListPocketData {
  const factory ListPocketData({
    @JsonKey(name: "pocket_id") required String pocketId,
    @JsonKey(name: "pocket_name") required String pocketName,
    @JsonKey(name: "pocket_description") required String pocketDescription,
    @JsonKey(name: "pocket_ammount") required int pocketAmmount,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "pocket_history")
    required List<TransactionListData> pocketHistory,
    @JsonKey(name: "wallet_owner") required WalletOwner walletOwner,
  }) = _ListPocketData;

  factory ListPocketData.fromJson(Map<String, dynamic> json) =>
      _$ListPocketDataFromJson(json);
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
