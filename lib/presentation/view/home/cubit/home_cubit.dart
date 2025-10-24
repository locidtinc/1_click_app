import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/get_daily_order_user_case.dart';
import 'package:one_click/presentation/view/home/cubit/home_state.dart';
import 'package:one_click/shared/constants/param_date.dart';

import '../../../../domain/entity/home_func.dart';
import '../../../../domain/usecase/get_store_info_use_case.dart';
import '../../../../shared/constants/local_storage/app_shared_preference.dart';
import '../../../../shared/constants/pref_keys.dart';
import '../../../routers/router.gr.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getStoreInfoUseCase, this._getDailyOrderUserCase)
      : super(HomeState());

  final GetStoreInfoUseCase _getStoreInfoUseCase;
  final GetDailyOrderUserCase _getDailyOrderUserCase;

  final List<HomeFuncEntity> listFunc = [
    const HomeFuncEntity(
      title: 'Đơn bán hàng',
      icon: '/ic_func_sale.svg',
      page: OrderManagerRoute(),
    ),
    const HomeFuncEntity(
      title: 'Đơn đặt hàng',
      icon: '/ic_func_order.svg',
      page: OrderImportRoute(),
    ),
    HomeFuncEntity(
      title: 'Quản lý sản phẩm',
      icon: '/ic_func_manage_product.svg',
      page: ProductManagerRoute(),
    ),
    const HomeFuncEntity(
      title: 'Quản lý khách hàng',
      icon: '/ic_func_manage_customer.svg',
      page: CustomerListRoute(),
    ),
    const HomeFuncEntity(
      title: 'Quản lý sự kiện',
      icon: '/logo_1click.svg',
      page: ParticipationEventRoute(),
    ),
    // const HomeFuncEntity(
    //   title: 'Sản phẩm MyKios',
    //   icon: '/logo_1click.png',
    //   page: MykiotStoreRoute(),
    // ),

    // const HomeFuncEntity(
    //   title: 'Kho',
    //   icon: '/ic_func_manage_product.svg',
    //   page: WarehouseListRouteV2(),
    // ),
  ];

  Future<void> getStoreInfo() async {
    final userId = AppSharedPreference.instance.getValue(PrefKeys.user) as int;
    final user = await _getStoreInfoUseCase.execute(StoreInfoInput(userId));
    await AppSharedPreference.instance
        .setValue(PrefKeys.store, jsonEncode(user.storeEntity.toJson()));
    emit(state.copyWith(storeEntity: user.storeEntity, isLoading: false));
  }

  Future<void> getDailyOrder({List<DateTime?>? datesSerach}) async {
    final input = (datesSerach != null && datesSerach.isNotEmpty)
        ? GetDailyOrderInput(
            dateStart: datesSerach[0],
            dateEnd: datesSerach.length > 1 ? datesSerach[1] : null,
          )
        : GetDailyOrderInput();

    final res = await _getDailyOrderUserCase.execute(input);
    emit(state.copyWith(dailyOderEntity: res.response.data));
  }

  void selectDatesSearch(ParamDate? param, List<DateTime?>? dates) {
    print('dates ${[param?.startDate, param?.endDate]}');
    print('param ${param!.endDate}');
    // if (dates == null || dates.isEmpty) return;
    emit(state.copyWith(
        dates: dates ?? [param.startDate, param.endDate], paramDate: param));
    // getCountOderFilter();
    Timer(const Duration(milliseconds: 350), () {
      getDailyOrder(datesSerach: state.dates);
    });
  }
  // void selectDatesSearch(List<DateTime?>? dates) {
  //   if (dates == null || dates.isEmpty) return;
  //   emit(
  //     state.copyWith(
  //       dates: dates,
  //     ),
  //   );
  //   Timer(const Duration(milliseconds: 350), () {
  //     getDailyOrder(datesSerach: state.dates);
  //   });
  // }

  void resetDate() {
    emit(state.copyWith(dates: []));
    Timer(const Duration(milliseconds: 350), () {
      getDailyOrder(datesSerach: state.dates);
    });
  }
}
