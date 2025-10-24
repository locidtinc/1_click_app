import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/usecase/delete_product_item_use_case.dart';
import 'package:one_click/domain/usecase/get_group_detail_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/view/group_detail/cubit/group_detail_state.dart';

import '../../../routers/router.gr.dart';

@injectable
class GroupDetailCubit extends Cubit<GroupDetailState> {
  GroupDetailCubit(
    this._getGroupDetailUseCase,
    this._deleteProductItemUseCase,
  ) : super(const GroupDetailState());

  final GetGroupDetailUseCase _getGroupDetailUseCase;
  final DeleteProductItemUseCase _deleteProductItemUseCase;

  bool isLoading = false;

  void getProductGroupDetail(int id) async {
    isLoading = true;
    final res = await _getGroupDetailUseCase.execute(id);
    emit(state.copyWith(groups: res));
    isLoading = false;
  }

  void onTapEditGroup(BuildContext context) async {
    final result =
        await context.router.push(GroupEditRoute(groups: state.groups));
    if (result != null && context.mounted) {
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text(
          'Cập nhật nhóm sản phẩm thành công',
          style: p6,
        ),
        click: () {
          Navigator.of(context).pop();
          final groups = result as GroupDetailEntity;
          emit(state.copyWith(groups: groups));
        },
      );
    }
  }

  void onTapDeleteCategory(BuildContext context) {
    DialogUtils.showErrorDialog(
      context,
      content: 'Xác nhận xoá nhóm sản phẩm này?',
      close: () => Navigator.of(context).pop(),
      accept: () async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          content: 'Đang xoá nhóm sản phẩm, vui lòng đợi!',
        );
        final res = await _deleteProductItemUseCase.execute(
          ProductItemInput(state.groups!.id ?? 0, 'productgroup'),
        );
        if (res.code == 200 && context.mounted) {
          Navigator.of(context).pop();
          DialogCustoms.showSuccessDialog(
            context,
            content: const Text('Xoá nhóm sản phẩm thành công!', style: p6),
            click: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(res.code);
            },
          );
        } else {
          Navigator.of(context).pop();
          DialogUtils.showErrorDialog(
            context,
            content: res.message ?? 'Xoá nhóm sản phẩm thất bại!',
          );
        }
      },
    );
  }
}
