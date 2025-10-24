import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/presentation/shared_view/order/cubit/order_state.dart';

@injectable
class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  void initData(int quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void onChangeQuantity(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(quantity: 0));
      return;
    }
    emit(state.copyWith(quantity: int.parse(value)));
    print(state.quantity);
  }

  void reduced() {
    if (state.quantity < 1) return;
    onChangeQuantity((state.quantity - 1).toString());
  }

  void incremented() {
    onChangeQuantity((state.quantity + 1).toString());
  }
}
