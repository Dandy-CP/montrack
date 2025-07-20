import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:montrack/models/transaction/transaction_model.dart';

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
    @JsonKey(name: "recent_transaction")
    required List<TransactionListData> recentTransaction,
    @JsonKey(name: "wallet_owner") required WalletOwner walletOwner,
  }) = _ActiveWalletData;

  factory ActiveWalletData.fromJson(Map<String, dynamic> json) =>
      _$ActiveWalletDataFromJson(json);
}

@freezed
abstract class UserGoal with _$UserGoal {
  const factory UserGoal({
    @JsonKey(name: "goals_id") required String goalsId,
    @JsonKey(name: "goals_name") required String goalsName,
    @JsonKey(name: "goals_description") required String goalsDescription,
    @JsonKey(name: "goals_set_amount") required int goalsSetAmount,
    @JsonKey(name: "goals_amount") required int goalsAmount,
    @JsonKey(name: "goals_attachment") required String goalsAttachment,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
  }) = _UserGoal;

  factory UserGoal.fromJson(Map<String, dynamic> json) =>
      _$UserGoalFromJson(json);
}

@freezed
abstract class UserPocket with _$UserPocket {
  const factory UserPocket({
    @JsonKey(name: "pocket_id") required String pocketId,
    @JsonKey(name: "pocket_name") required String pocketName,
    @JsonKey(name: "pocket_description") required String pocketDescription,
    @JsonKey(name: "pocket_ammount") required int pocketAmmount,
    @JsonKey(name: "wallet_owner_id") required String walletOwnerId,
    @JsonKey(name: "created_at") required String createdAt,
  }) = _UserPocket;

  factory UserPocket.fromJson(Map<String, dynamic> json) =>
      _$UserPocketFromJson(json);
}

@freezed
abstract class WalletOwner with _$WalletOwner {
  const factory WalletOwner({
    @JsonKey(name: "user_id") required String userId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
  }) = _WalletOwner;

  factory WalletOwner.fromJson(Map<String, dynamic> json) =>
      _$WalletOwnerFromJson(json);
}
