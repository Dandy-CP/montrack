import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/transaction/transaction_model.dart';

part 'pocket_detail_model.freezed.dart';
part 'pocket_detail_model.g.dart';

@freezed
abstract class PocketDetailResponse with _$PocketDetailResponse {
  const factory PocketDetailResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required PocketDetailData data,
  }) = _PocketDetailResponse;

  factory PocketDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PocketDetailResponseFromJson(json);
}

@freezed
abstract class PocketDetailData with _$PocketDetailData {
  const factory PocketDetailData({
    @JsonKey(name: "pocket_id") required String pocketId,
    @JsonKey(name: "pocket_name") required String pocketName,
    @JsonKey(name: "pocket_emoji") required String pocketEmoji,
    @JsonKey(name: "pocket_description") required String pocketDescription,
    @JsonKey(name: "pocket_ammount") required int pocketAmmount,
    @JsonKey(name: 'pocket_set_amount') required int pocketSetAmount,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "pocket_history")
    required List<TransactionListData> pocketHistory,
  }) = _PocketDetailData;

  factory PocketDetailData.fromJson(Map<String, dynamic> json) =>
      _$PocketDetailDataFromJson(json);
}
