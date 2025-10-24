import 'package:freezed_annotation/freezed_annotation.dart';
part 'card.freezed.dart';
part 'card.g.dart';

@freezed
class CardEntity with _$CardEntity {
  const CardEntity._();

  const factory CardEntity({
    final int? id,
    @Default('') String fullName,
    @Default('') String cardNumber,
    @Default('') String titleBank,
    @Default('') String shortNameBank,
    @Default('') String codeBank,
    final String? imgCard,
  }) = _CardEntity;

  factory CardEntity.fromJson(Map<String, dynamic> json) =>
      _$CardEntityFromJson(json);
}
