import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'order_manager_state.dart';

@injectable
class OrderManagerCubit extends Cubit<OrderManagerState> {
  OrderManagerCubit() : super(const OrderManagerState());
}
