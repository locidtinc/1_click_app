import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';

import '../../shared/constants/pref_keys.dart';
import 'base/io/base_output.dart';

@injectable
class OrderDetailDrafUseCase
    extends BaseUseCase<OrderDetailDrafInput, OrderDetailDrafOutput> {
  @override
  OrderDetailDrafOutput buildUseCase(OrderDetailDrafInput input) {
    final shared = AppSharedPreference.instance;
    final resJson = shared.getValue(
      input.typeOrder == TypeOrder.cHTH
          ? PrefKeys.orderDrafExport
          : PrefKeys.orderDrafImport,
    );
    if (resJson == null) return OrderDetailDrafOutput(null);
    final listJson = jsonDecode(resJson as String);
    final listOrder =
        (listJson as List).map((e) => OrderDetailEntity.fromJson(e)).toList();
    final order = listOrder.firstWhere((e) => e.id == input.id);
    return OrderDetailDrafOutput(order);
  }
}

class OrderDetailDrafInput extends BaseInput {
  final TypeOrder typeOrder;
  final int id;
  OrderDetailDrafInput({
    required this.id,
    required this.typeOrder,
  });
}

class OrderDetailDrafOutput extends BaseOutput {
  final OrderDetailEntity? order;
  OrderDetailDrafOutput(this.order);
}
