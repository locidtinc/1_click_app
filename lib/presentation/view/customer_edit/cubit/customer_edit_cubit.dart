import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/customer.dart';
import '../../../../domain/entity/customer_create.dart';
import '../../../../domain/usecase/customer_edit_use_case.dart';
import '../../../routers/router.gr.dart';
import 'customer_edit_state.dart';

@injectable
class CustomerEditCubit extends Cubit<CustomerEditState> {
  CustomerEditCubit(this._customerEditUseCase)
      : super(const CustomerEditState());

  final CustomerEditUseCase _customerEditUseCase;

  final formKey = GlobalKey<FormState>();

  void initData(CustomerEntity? customer) {
    emit(state.copyWith(customerEntity: customer));
  }

  void updateFieldCustomer({
    String? name,
    String? phone,
    int? gender,
    String? address,
    String? email,
    String? birthday,
  }) {
    final customerEdit = state.customerEntity?.copyWith(
      fullName: name ?? state.customerEntity?.fullName,
      phone: phone ?? state.customerEntity?.phone,
      gender: gender ?? state.customerEntity?.gender ?? 1,
      // address: address ?? state.customerEntity?.address,
      email: email ?? state.customerEntity?.email,
      birthday: birthday ?? state.customerEntity?.birthday,
    );
    emit(state.copyWith(customerEntity: customerEdit));
  }
}

extension ApiEvent on CustomerEditCubit {
  Future<void> editCustomer(BuildContext context) async {
    final validate = formKey.currentState?.validate();
    if (!(validate ?? false)) return;

    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang cập nhật thông tin, vui lòng đợi!',
    );

    final input = CustomerEditInput(
      CustomerCreateEntity(
        fullName: state.customerEntity?.fullName ?? '',
        phone: state.customerEntity?.phone ?? '',
        gender: state.customerEntity?.gender ?? 1,
        // address: state.customerEntity?.address ?? '',
        email: state.customerEntity?.email ?? '',
        birthday: state.customerEntity?.birthday ?? '',
      ),
      state.customerEntity?.id,
    );
    final res = await _customerEditUseCase.execute(input);
    if (res.responseModel.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      DialogUtils.showSuccessDialog(
        context,
        content: 'Cập nhật thông tin thành công',
        titleClose: 'Về danh sách',
        titleConfirm: 'Chi tiết',
        accept: () {
          context.router
              .popUntil((route) => route.settings.name == 'CustomerListRoute');
          context.router.push(
            CustomerDetailRoute(customerEntity: res.responseModel.data!),
          );
        },
        close: () => context.router
            .popUntil((route) => route.settings.name == 'CustomerListRoute'),
      );
    } else {
      Navigator.of(context).pop();
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật thông tin thất bại',
      );
    }
  }
}
