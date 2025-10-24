import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/order_create.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/entity/order_import_create.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/domain/usecase/customer_get_list_use_case.dart';
import 'package:one_click/domain/usecase/order_create_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_by_scan_bar_code_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_list_department_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_list_use_case.dart';
import 'package:one_click/presentation/view/card_bank/cubit/card_bank_cubit.dart';
import 'package:one_click/shared/constants/enum/system_code.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../../domain/entity/order_status.dart';
import '../../../../domain/entity/qr_code_payment.dart';
import '../../../../domain/usecase/order_qrcode_use_case.dart';
import '../../../../domain/usecase/update_status_payment_order_use_case.dart';
import '../../../routers/router.gr.dart';
import 'order_create_state.dart';

@injectable
class OrderCreateCubit extends Cubit<OrderCreateState> {
  OrderCreateCubit(
    this._variantGetListUseCase,
    this._variantGetByScanBarcodeUseCase,
    this._orderCreateUseCase,
    this._customerGetListUseCase,
    this._orderQrcodeUseCase,
    this._cardBankCubit,
    this._updateStatusPaymentOrderUseCase,
    this._variantGetListDepartmentUseCase,
  ) : super(const OrderCreateState());

  final VariantGetListDepartmentUseCase _variantGetListDepartmentUseCase;
  final VariantGetByScanBarcodeUseCase _variantGetByScanBarcodeUseCase;
  final OrderCreateUseCase _orderCreateUseCase;
  final CustomerGetListUseCase _customerGetListUseCase;
  final OrderQrcodeUseCase _orderQrcodeUseCase;
  final CardBankCubit _cardBankCubit;
  final UpdateStatusPaymentOrderUseCase _updateStatusPaymentOrderUseCase;
  final VariantGetListUseCase _variantGetListUseCase;
  final InfiniteListController<VariantCreateOrderEntity>
      infiniteListController =
      InfiniteListController<VariantCreateOrderEntity>.init();
  final ScrollController scrollController = ScrollController();

  Timer? timer;

  void _totalPrice() {
    _totalPriceDefault();
    final totalPrice = state.listVariantSelect.fold(0, (total, item) {
      if (item.isChoose) {
        total += item.amount * item.priceSell;
      }
      return total;
    });
    emit(state.copyWith(totalPrice: totalPrice));
  }

  void _totalPriceDefault() {
    final totalPrice = state.listVariantSelect.fold(0, (total, item) {
      if (item.isChoose) {
        total += item.amount * item.priceSellDefault;
      }
      return total;
    });
    emit(state.copyWith(totalPriceDefault: totalPrice));
  }

  void noteChange(String value) {
    emit(state.copyWith(note: value));
  }

  void customerChange(int id) {
    final customer = state.listCustomer.firstWhere((e) => e.id == id);
    emit(
      state.copyWith(
        customer: id,
        selectedCustomer: customer,
      ),
    );
  }

  void searchKeyChange(String value) {
    emit(state.copyWith(searchKey: value));

    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(seconds: 1), () {
      infiniteListController.onRefresh();
    });
  }

  void typePaymentChange(TypePayment item) {
    emit(state.copyWith(typePayment: item));
  }

  void initData(TypeOrder typeOrder, int? customer) {
    emit(
      state.copyWith(
        typeOrder: typeOrder,
        customer: customer,
      ),
    );
    getListCustomer();
  }

  /// use when create order by order draf
  void updateOrderInfo(OrderDetailEntity? order) {
    emit(
      state.copyWith(
        listVariantSelect: (order?.variants ?? [])
            .map(
              (e) => VariantCreateOrderEntity(
                id: e.id,
                amount: e.amount ?? 0,
                priceSell: e.priceSell ?? 0,
                inventory: 10000000000,
              ),
            )
            .toList(),
        customer: order?.customerData?.id,
      ),
    );
    _totalPrice();
  }

  void validateCreateOrder() {
    for (final item in state.listVariantSelect) {
      if (item.amount == 0) {
        emit(state.copyWith(failureCreateOrder: FailureCreateOrder.quantity));
        return;
      } else if (item.inventory == 0 && state.typeOrder == TypeOrder.cHTH) {
        emit(
          state.copyWith(
            failureCreateOrder: FailureCreateOrder.inventoryEmpty,
          ),
        );
        return;
      } else if (item.inventory < item.amount &&
          state.typeOrder == TypeOrder.cHTH) {
        emit(
          state.copyWith(
            failureCreateOrder: FailureCreateOrder.inventoryNotEnough,
          ),
        );
        return;
      } else {
        emit(state.copyWith(failureCreateOrder: null));
      }
    }
  }
}

extension VariantEditHandle on OrderCreateCubit {
  void checkboxToggle(VariantCreateOrderEntity variant) {
    final updatedList =
        List<VariantCreateOrderEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    if (index == -1) {
      updatedList.add(variant.copyWith(isChoose: true));
    } else {
      updatedList.remove(variant);
    }
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  void changeAmount(VariantCreateOrderEntity variant, int value) {
    final updatedList =
        List<VariantCreateOrderEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    updatedList[index] = updatedList[index].copyWith(amount: value);
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  void deleteVariant(VariantCreateOrderEntity variant) {
    final updatedList =
        List<VariantCreateOrderEntity>.from(state.listVariantSelect)
          ..removeWhere((e) => e == variant);
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  void priceChange(VariantCreateOrderEntity variant, String value) {
    final updatedList =
        List<VariantCreateOrderEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    final newPrice =
        int.parse(value.isNotEmpty ? value.replaceAll('.', '') : '0');
    updatedList[index] = updatedList[index].copyWith(priceSell: newPrice);
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  Future<List<VariantCreateOrderEntity>> getList(int page) async {
    final input = VariantGetListInput(
      limit: state.limit,
      page: page + 1,
      searchKey: state.searchKey,
      status: true,
      accountSystemCode:
          state.typeOrder == TypeOrder.ad ? SystemCode.ad.code : null,
    );
    final res = await _variantGetListUseCase.execute(input);
    return res.response.data ?? <VariantCreateOrderEntity>[];
  }

  // Future<List<VariantCreateOrderEntity>> getListVariant(int page) async {
  //   final input = VariantGetListDepartmentInput(
  //     limit: state.limit,
  //     page: page + 1,
  //     searchKey: state.searchKey,
  //     status: true,
  //     accountSystemCode: state.typeOrder == TypeOrder.ad ? SystemCode.ad.code : null,
  //   );
  //   final res = await _variantGetListDepartmentUseCase.execute(input);
  //   return res.response.data?.where((e) => e.status != false).toList() as List<VariantCreateOrderEntity>;
  //   // return res.response.data ?? <VariantCreateOrderEntity>[];
  // }
  Future<List<VariantCreateOrderEntity>> getListVariant(int page) async {
    final input = VariantGetListDepartmentInput(
      page: page + 1,
      limit: state.limit,
      searchKey: state.searchKey,
    );
    final res = await _variantGetListDepartmentUseCase.execute(input);
    final data = res.response.data ?? [];
    // final filtered = data.where((e) => e.status != false && (e.inventory != 0)).toList();
    // // Gọi tiếp nếu sau lọc < limit nhưng API trả đủ limit
    // if (filtered.length < state.limit && data.length == state.limit) {
    //   final next = await getListVariant(page + 1);
    //   filtered.addAll(next);
    // }
    // if (filtered.length < state.limit) {
    //   print('[Page $page] Đã hết dữ liệu');
    // }
    return data;
  }

  Future<void> getVariantByScanBarcode(
    BuildContext context,
    String barcode,
  ) async {
    final res = await _variantGetByScanBarcodeUseCase
        .execute(VariantGetByScanBarcodeInput(barcode));
    print('res.response.code ${res.response.code}');
    // check status code response and list variant is not empty
    if (res.response.code == 200 && (res.response.data?.isNotEmpty ?? false)) {
      final listVariant =
          List<VariantCreateOrderEntity>.from(state.listVariantSelect);
      final index = listVariant.indexWhere(
        (e) => e.id == res.response.data![0].id,
      );
      if (index != -1 && context.mounted) {
        listVariant[index] =
            listVariant[index].copyWith(amount: listVariant[index].amount + 1);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: green_1,
            content: Text(
              'Sản phẩm đã tồn tại, số lượng được thêm 1',
              style: p5.copyWith(color: whiteColor),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        listVariant.add(res.response.data![0].copyWith(isChoose: true));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: green_1,
            content: Text(
              'Thêm mới sản phẩm thành công',
              style: p5.copyWith(color: whiteColor),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      emit(
        state.copyWith(
          listVariantSelect: listVariant,
          loadingInit: false,
        ),
      );
      _totalPrice();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: red_1,
          content: Text(
            'Không tìm thấy sản phẩm hoặc không đủ tồn kho (Hoặc đã bị ẩn)',
            style: p5.copyWith(color: whiteColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}

extension CreateOrderHandle on OrderCreateCubit {
  Future<OrderCreateOutput> createOrder(bool? isOnline) async {
    switch (state.typeOrder) {
      case TypeOrder.cHTH:
        return createOrderExport(isOnline);
      default:
        return createOrderImport();
    }
  }

  OrderDetailEntity createOrderDraf() {
    switch (state.typeOrder) {
      case TypeOrder.cHTH:
        return createOrderDrafExport();
      default:
        return createOrderDrafExport();
    }
  }

  Future<OrderCreateOutput> createOrderExport(bool? isOnline) async {
    final orderItem = state.listVariantSelect
        .map(
          (e) => Orderitem(
            variant: e.id,
            quantity: e.amount,
            price: e.priceSell,
          ),
        )
        .toList();
    final orderCreateEntity = OrderCreateEntity(
      order: OrderInfoCreate(
        title:
            'Đơn hàng mới ${DateFormat('hh:mm - dd/MM/y').format(DateTime.now())}',
        customer: state.customer,
        note: state.note,
        isOnline: isOnline ?? false,
      ),
      orderitem: orderItem,
    );

    final res = await _orderCreateUseCase
        .execute(OrderCreateInput(orderCreateEntity: orderCreateEntity));
    emit(state.copyWith(orderDetailEntity: res.response.data));
    return res;
  }

  Future<OrderCreateOutput> createOrderImport() async {
    final orderItem = state.listVariantSelect
        .map(
          (e) => Orderitem(
            variant: e.id,
            quantity: e.amount,
            price: e.priceSellDefault,
            discount: e.priceSellDefault - e.priceSell,
          ),
        )
        .toList();
    final orderImportCreateEntity = OrderImportCreateEntity(
      order: OrderImportInfoCreate(
        note: state.note,
        discount: (state.totalPriceDefault - state.totalPrice).toString(),
        total: state.totalPriceDefault.toString(),
      ),
      orderitem: orderItem,
    );
    final res = await _orderCreateUseCase.execute(
      OrderCreateInput(orderImportCreateEntity: orderImportCreateEntity),
    );
    return res;
  }

  /// Save Order with status [Draf] in to [AppSharedPreference]
  ///
  /// In [AppSharedPreference] with keys [PrefKeys.orderDrafExport]
  ///
  /// Type is List[OrderDetailEntity]
  OrderDetailEntity createOrderDrafExport() {
    final shared = AppSharedPreference.instance;

    final id = Random().nextInt(1000000000);
    final orderDetailDraf = OrderDetailEntity(
      id: id,
      code: '#DRAF-$id',
      orderStatus: const OrderStatusEntity(
        id: PrefKeys.idOrderDrafStatus,
        title: 'Dự thảo',
        code: 'DRAF',
      ),
      customerData: state.customer == null
          ? null
          : CustomerEntity(
              id: state.listCustomer
                  .firstWhere((e) => e.id == state.customer)
                  .id,
              fullName: state.listCustomer
                  .firstWhere((e) => e.id == state.customer)
                  .fullName,
              phone: state.listCustomer
                  .firstWhere((e) => e.id == state.customer)
                  .phone,
              email: state.listCustomer
                  .firstWhere((e) => e.id == state.customer)
                  .email,
              image: state.listCustomer
                  .firstWhere((e) => e.id == state.customer)
                  .image,
            ),
      createAt: DateFormat('hh:mm - dd/MM/y').format(DateTime.now()),
      total: state.totalPrice,
      variants: state.listVariantSelect
          .map(
            (e) => OrderItemEntity(
              id: e.id,
              name: e.title,
              amount: (e.amount).round(),
              priceSell: (e.priceSell).round(),
              image: e.image,
              models: (e.optionsData).fold('', (model, e) {
                model = model! + (model.isEmpty ? '' : ', ') + e.values;
                return model;
              }),
            ),
          )
          .toList(),
      shopData: null,
    );

    late List listOrderDrafExport;

    final rawValue = shared.getValue(PrefKeys.orderDrafExport);

    if (rawValue == null) {
      listOrderDrafExport = [];
    } else {
      listOrderDrafExport = jsonDecode(rawValue as String);
    }

    listOrderDrafExport.add(orderDetailDraf.toJson());
    shared.setValue(PrefKeys.orderDrafExport, jsonEncode(listOrderDrafExport));
    return orderDetailDraf;
  }

  Future<QrCodePayment?> qrCodePayment() async {
    final cardBank = await _cardBankCubit.getCard();
    if (cardBank == null || state.orderDetailEntity?.id == null) {
      print(cardBank);
      print(state.orderDetailEntity?.id);
      return null;
    }
    final input = OrderQrcodeInput(
      cardId: cardBank.id ?? 0,
      orderId: state.orderDetailEntity!.id!,
    );
    final res = await _orderQrcodeUseCase.execute(input);
    return res.response.data;
  }

  Future<BaseResponseModel> updatePayment(BuildContext context) async {
    final input = UpdateStatusPaymentOrderInput(
      state.orderDetailEntity?.id ?? 0,
      true,
    );
    final res = await _updateStatusPaymentOrderUseCase.execute(input);
    return res.response;
  }
}

extension CustomerApiHandle on OrderCreateCubit {
  Future<void> getListCustomer() async {
    emit(state.copyWith(loadingInit: true));
    try {
      final CustomerGetListInput input = CustomerGetListInput('', 1000, 1);
      final res = await _customerGetListUseCase.execute(input);
      emit(state.copyWith(
          listCustomer: res.response.data ?? [], loadingInit: false));
    } catch (e) {
      emit(state.copyWith(loadingInit: false));
    }
  }
}

class CustomerDropdownValue {
  final int? id;
  final String? name;
  final String? phone;

  CustomerDropdownValue({
    this.id,
    this.name,
    this.phone,
  });
}
