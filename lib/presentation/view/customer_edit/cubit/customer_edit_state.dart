import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/customer.dart';

part 'customer_edit_state.freezed.dart';

@freezed
class CustomerEditState with _$CustomerEditState {
  const factory CustomerEditState({
    @Default(null) CustomerEntity? customerEntity,
  }) = _CustomerEditState;
}
