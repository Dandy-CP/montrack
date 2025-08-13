import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/wallet/wallet_list_model.dart';

part 'active_wallet_model.freezed.dart';
part 'active_wallet_model.g.dart';

@freezed
abstract class ActiveWalletResponse with _$ActiveWalletResponse {
  const factory ActiveWalletResponse({
    @JsonKey(name: "statusCode") required int statusCode,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "timeStamp") required String timeStamp,
    @JsonKey(name: "data") required ActiveWalletData data,
  }) = _ActiveWalletResponse;

  factory ActiveWalletResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveWalletResponseFromJson(json);
}

@freezed
abstract class ActiveWalletData with _$ActiveWalletData {
  const factory ActiveWalletData({
    @JsonKey(name: "wallet_id") required String walletId,
    @JsonKey(name: "wallet_name") required String walletName,
    @JsonKey(name: "wallet_amount") required int walletAmount,
    @JsonKey(name: "is_wallet_active") required bool isWalletActive,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "user_goals") required List<UserGoal> userGoals,
    @JsonKey(name: "user_pocket") required List<UserPocket> userPocket,
  }) = _ActiveWalletData;

  factory ActiveWalletData.fromJson(Map<String, dynamic> json) =>
      _$ActiveWalletDataFromJson(json);
}
