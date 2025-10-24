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
class OrderDrafUseCase extends BaseUseCase<OrderDrafInput, OrderDrafOutput> {
  @override
  OrderDrafOutput buildUseCase(OrderDrafInput input) {
    final shared = AppSharedPreference.instance;
    final resJson = shared.getValue(
      input.typeOrder == TypeOrder.cHTH
          ? PrefKeys.orderDrafExport
          : PrefKeys.orderDrafImport,
    );
    if (resJson == null) return OrderDrafOutput([]);
    final listJson = jsonDecode(resJson as String);
    return OrderDrafOutput(
        (listJson as List).map((e) => OrderDetailEntity.fromJson(e)).toList());
  }
}

class OrderDrafInput extends BaseInput {
  final TypeOrder typeOrder;
  OrderDrafInput(this.typeOrder);
}

class OrderDrafOutput extends BaseOutput {
  final List<OrderDetailEntity> listOrder;
  OrderDrafOutput(this.listOrder);
}
