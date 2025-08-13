import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/transaction/transaction_model.dart';

part 'goals_detail_model.freezed.dart';
part 'goals_detail_model.g.dart';

@freezed
abstract class GoalsDetailResponse with _$GoalsDetailResponse {
  const factory GoalsDetailResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required GoalsDetailData data,
  }) = _GoalsDetailResponse;

  factory GoalsDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalsDetailResponseFromJson(json);
}

@freezed
abstract class GoalsDetailData with _$GoalsDetailData {
  const factory GoalsDetailData({
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
  }) = _GoalsDetailData;

  factory GoalsDetailData.fromJson(Map<String, dynamic> json) =>
      _$GoalsDetailDataFromJson(json);
}
