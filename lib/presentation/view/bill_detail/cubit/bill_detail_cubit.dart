import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';

import 'bill_detail_state.dart';

@injectable
class BillDetailCubit extends Cubit<BillDetailState> {
  BillDetailCubit() : super(const BillDetailState());

  void orderDetailEntityChange(OrderDetailEntity value) {
    emit(state.copyWith(orderDetailEntity: value));
  }

  void typeOrderChange(TypeOrder value) {
    emit(state.copyWith(typeOrder: value));
  }
}
