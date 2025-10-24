import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_variant_state.freezed.dart';

@freezed
class EditVariantState with _$EditVariantState {
  const factory EditVariantState({
    String? barCode,
    String? priceSell,
    String? priceImport,
    @Default(false) bool isSell,
    @Default(null) int? amount,
    XFile? image,
  }) = _EditVariantState;
}
