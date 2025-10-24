import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/customer_create/cubit/customer_create_cubit.dart';
import 'package:one_click/shared/utils/event.dart';

class CustomerCreatePopup extends StatefulWidget {
  const CustomerCreatePopup({
    super.key,
    this.onConfirm,
    this.value,
  });

  final Function(CustomerEntity? customer)? onConfirm;
  final String? value;
  @override
  State<CustomerCreatePopup> createState() => _CustomerCreatePopupState();
}

class _CustomerCreatePopupState extends State<CustomerCreatePopup> {
  final myBloc = getIt.get<CustomerCreateCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      final isPhone = isPhoneNumberValid(widget.value!);
      if (isPhone) {
        myBloc.phoneChange(widget.value!);
      } else {
        myBloc.fullNameChange(widget.value ?? '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerCreateCubit>(
      create: (context) => myBloc,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sp16),
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              width: widthDevice(context) - sp32,
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp16),
              ),
              child: Form(
                key: myBloc.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Thêm mới khách hàng',
                      style: p3.copyWith(color: blackColor),
                    ),
                    const SizedBox(height: sp24),
                    AppInput(
                      label: 'Tên khách hàng',
                      hintText: 'Nhập tên khách hàng',
                      required: true,
                      initialValue: myBloc.state.fullName,
                      textInputType: TextInputType.name,
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập tên khách hàng';
                        }
                      },
                      onChanged: (value) => myBloc.fullNameChange(value),
                    ),
                    const SizedBox(height: sp16),
                    AppInput(
                      label: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                      required: true,
                      initialValue: myBloc.state.phone,
                      textInputType: TextInputType.phone,
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        if (!isPhoneNumberValid(value ?? '')) {
                          return 'Vui lòng nhập đúng định dạng số điện thoại';
                        }
                      },
                      onChanged: (value) => myBloc.phoneChange(value),
                    ),
                    const SizedBox(height: sp16),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Thêm mới',
                        event: () => createCustomer(context),
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createCustomer(BuildContext context) async {
    final validate = myBloc.formKey.currentState?.validate();
    if (!(validate ?? false)) return;
    final customer = await myBloc.createCustomer(context, isCheck: true);
    widget.onConfirm?.call(customer);
    // context.router.popUntil((route) => route.settings.name == 'OrderCreateConfirmRoute');
  }
}
