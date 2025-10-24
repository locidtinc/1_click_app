import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:one_click/domain/usecase/get_list_variant_promotion_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_list_use_case.dart';
import '../../../../domain/entity/variant_entity.dart';
import '../../../../shared/constants/enum/system_code.dart';
import 'mykiot_store_state.dart';

@injectable
class MykiotStoreCubit extends Cubit<MykiotStoreState> {
  MykiotStoreCubit(
    this._getListVariantPromotionUseCase,
    this._variantGetListUseCase,
  ) : super(const MykiotStoreState());

  final GetListVariantPromotionUseCase _getListVariantPromotionUseCase;
  final VariantGetListUseCase _variantGetListUseCase;
  final ScrollController scrollController = ScrollController();
  final ScrollController scPagePromotion = ScrollController();
  final FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();

  Timer? timerSearchPromotion;

  void init() {
    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      const delta = 50; // or something else..
      if (maxScroll - currentScroll <= delta &&
          !state.isLoadingProduct &&
          state.listVariants.length % state.limit == 0) {
        // whatever you determine here
        //.. load more
        emit(state.copyWith(page: state.page + 1));
        getVariants();
      }
    });
    scPagePromotion.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      const delta = 50; // or something else..
      if (maxScroll - currentScroll <= delta &&
          !state.isLoadingProduct &&
          state.listVariantPromotion.length % state.limit == 0) {
        // whatever you determine here
        //.. load more
        emit(state.copyWith(page: state.pagePromotion + 1));
        getVariantPromotion();
      }
    });
    getVariantPromotion();
    getVariants();
  }

  void onFieldChange({String? keySearchPromotion}) {
    emit(
      state.copyWith(
        keySearchPromotion: keySearchPromotion ?? state.keySearchPromotion,
      ),
    );
  }

  void onSearchPromotion(String keySearchPromotion) {
    emit(
      state.copyWith(
        keySearchPromotion: keySearchPromotion,
      ),
    );

    if (timerSearchPromotion != null) {
      timerSearchPromotion?.cancel();
    }

    timerSearchPromotion = Timer(const Duration(milliseconds: 500), () {
      getVariantPromotion();
    });
  }
}

extension ApiEvent on MykiotStoreCubit {
  Future<void> getVariantPromotion() async {
    emit(state.copyWith(isLoadingProductPromotion: true));
    final input = GetListVariantPromotionInput(
      page: state.pagePromotion,
      limit: state.limit,
      keySearch: state.keySearchPromotion,
    );
    final res = await _getListVariantPromotionUseCase.execute(input);
    switch (state.keySearchPromotion) {
      case '':
        var listState = List<VariantEntity>.from(state.listVariantPromotion);
        listState += res.response.data ?? [];
        emit(
          state.copyWith(
            listVariantPromotion: listState,
            isLoadingProductPromotion: false,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            listVariantPromotionSearch: res.response.data ?? [],
            isLoadingProductPromotion: false,
          ),
        );
    }
  }

  Future<void> getVariants() async {
    emit(
      state.copyWith(
        isLoadingProduct: true,
      ),
    );
    final input = VariantGetListInput(
      limit: state.limit,
      page: state.page,
      searchKey: '',
      accountSystemCode: SystemCode.ad.code,
      status: true,
    );
    final res = await _variantGetListUseCase.execute(input);
    var listState = List<VariantEntity>.from(state.listVariants);
    listState += res.responseEntity.data ?? [];
    emit(
      state.copyWith(
        listVariants: listState,
        isLoadingProduct: false,
      ),
    );
  }

  Future<void> getVariantsSearch({String? searchKey}) async {
    emit(
      state.copyWith(
        isLoadingSearch: true,
      ),
    );
    final input = VariantGetListInput(
      limit: state.limit,
      page: state.page,
      searchKey: searchKey ?? '',
      accountSystemCode: SystemCode.ad.code,
      status: true,
    );
    final res = await _variantGetListUseCase.execute(input);
    emit(
      state.copyWith(
        listSearch: res.responseEntity.data ?? [],
        isLoadingSearch: false,
      ),
    );
  }

  void clearDataSearch() {
    emit(state.copyWith(listSearch: []));
  }
}
