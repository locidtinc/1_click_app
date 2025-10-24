import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/usecase/get_store_info_use_case.dart';
import 'package:one_click/domain/usecase/put_avatar_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/store_information/cubit/store_information_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@injectable
class StoreInformationCubit extends Cubit<StoreInformationState> {
  StoreInformationCubit(this._getStoreInfoUseCase, this._avatarUseCase)
      : super(const StoreInformationState());

  final GetStoreInfoUseCase _getStoreInfoUseCase;
  final PutAvatarUseCase _avatarUseCase;
  bool isLoading = true;

  Future<void> getStoreInfo() async {
    isLoading = true;
    final userId = AppSharedPreference.instance.getValue(PrefKeys.user) as int;
    final user = await _getStoreInfoUseCase.execute(StoreInfoInput(userId));
    await AppSharedPreference.instance
        .setValue(PrefKeys.store, jsonEncode(user.storeEntity.toJson()));
    emit(state.copyWith(storeEntity: user.storeEntity));
    isLoading = false;
  }

  void logout(BuildContext context) {
    DialogCustoms.showNotifyDialog(
      context,
      content: const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Text('Bạn có muốn thoát khỏi ứng dụng không?'),
      ),
      click: () async {
        isLoading = true;
        await AppSharedPreference.instance.remove(PrefKeys.token);
        await AppSharedPreference.instance.remove(PrefKeys.user);
        await AppSharedPreference.instance.remove(PrefKeys.orderDrafExport);
        await AppSharedPreference.instance.remove(PrefKeys.orderDrafImport);
        await AppSharedPreference.instance.remove(PrefKeys.card);
        await AppSharedPreference.instance.remove(PrefKeys.cart);
        await AppSharedPreference.instance.remove(PrefKeys.warehouseId);
        await AppSharedPreference.instance.remove(PrefKeys.dataCHTH);
        await AppSharedPreference.instance.remove(PrefKeys.priceList);
        // await AppSharedPreference.instance.clear();
        isLoading = false;
        context.router.pushAndPopUntil(
          const LoginV2Route(),
          predicate: (Route<dynamic> route) => false,
        );
      },
    );
  }

  void deleteAccount(BuildContext context) {
    DialogUtils.showErrorDialog(
      context,
      content: 'Xác nhận vô hiệu hoá tài khoản',
      titleClose: 'Huỷ bỏ',
      titleConfirm: 'Tiếp tục',
      close: () {
        Navigator.of(context).pop();
      },
      accept: () async {
        final id = AppSharedPreference.instance.getValue(PrefKeys.user);
        final res = await BaseDio().dio().put(
          Api.updateStatusAccount,
          data: {
            'status': false,
            'list_account': [id],
          },
        );
        if (res.data['code'] == 200) {
          await AppSharedPreference.instance.clear();
          context.router.pushAndPopUntil(
            const LoginV2Route(),
            predicate: (Route<dynamic> route) => false,
          );
        }
      },
    );
    // DialogCustoms.showNotifyDialog(
    //   context,
    //   content: const Padding(
    //     padding: EdgeInsets.only(bottom: sp24),
    //     child: Text('Bạn có muốn thoát khỏi ứng dụng không?'),
    //   ),
    //   click: () async {
    //     isLoading = true;
    //     await AppSharedPreference.instance.remove(PrefKeys.token);
    //     await AppSharedPreference.instance.remove(PrefKeys.user);
    //     await AppSharedPreference.instance.clear();
    //     isLoading = false;
    //     context.router.pushAndPopUntil(
    //       const LoginV2Route(),
    //       predicate: (Route<dynamic> route) => false,
    //     );
    //   },
    // );
  }

  void onTapEditStore(BuildContext context, StoreEntity store) async {
    final result = await context.router.push(EditStoreRoute(store: store));
    if (result != null && result == 200 && context.mounted) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Cập nhật cửa hàng thành công',
        accept: () async {
          Navigator.of(context).pop();
          await getStoreInfo();
        },
      );
    }
  }

  void onTapAddBank(BuildContext context) async {
    final result = await context.router.push(AddBankRoute());
    if (result != null) {
      final card = result as CardDataEntity;
      emit(
        state.copyWith(
          storeEntity: state.storeEntity.copyWith(cardData: card),
        ),
      );
    }
  }

  void onTapAvatar(BuildContext context, int storeId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(imageQuality: 10, source: ImageSource.gallery);

    if (image != null) {
      final payload = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      DialogUtils.showLoadingDialog(context, content: 'Đang tải...');
      try {
        final res =
            await _avatarUseCase.execute(PutAvatarInput(payload, storeId));
        if (res.response.code == 200) {
          await getStoreInfo();
        } else {
          print('Lỗi upload: ${res.response.message}');
        }
      } catch (e) {
        print('Lỗi: $e');
      } finally {
        Navigator.of(context).pop();
      }
    }
  }
}
