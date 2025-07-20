import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_model.freezed.dart';
part 'meta_model.g.dart';

@freezed
abstract class Meta with _$Meta {
  const factory Meta({
    @JsonKey(name: "isFirstPage") required bool isFirstPage,
    @JsonKey(name: "isLastPage") required bool isLastPage,
    @JsonKey(name: "currentPage") required int currentPage,
    @JsonKey(name: "previousPage") required dynamic previousPage,
    @JsonKey(name: "nextPage") required dynamic nextPage,
    @JsonKey(name: "pageCount") required int pageCount,
    @JsonKey(name: "totalCount") required int totalCount,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}
