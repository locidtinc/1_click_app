import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/address/address_widget.dart';
import 'package:one_click/presentation/view/customer_create/cubit/customer_create_cubit.dart';
import 'package:one_click/presentation/view/customer_edit/cubit/customer_edit_state.dart';
import 'package:one_click/shared/utils/dismiss_keyboard.dart';

import '../../../shared/utils/event.dart';
import '../../base/select.dart';
import 'cubit/customer_edit_cubit.dart';

@RoutePage()
class CustomerEditPage extends StatefulWidget {
  CustomerEditPage({
    super.key,
    required this.customer,
  });

  final CustomerEntity? customer;

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final myBloc = getIt.get<CustomerEditCubit>();

  final birthdayTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerEditCubit>(
      create: (context) => myBloc..initData(widget.customer),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => AppUtils.dissmissKeyboard(),
        child: Scaffold(
          appBar: const BaseAppBar(title: 'Chỉnh sửa thông tin khách hàng'),
          body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  BlocBuilder<CustomerEditCubit, CustomerEditState>(
                    builder: (context, state) {
                      if (birthdayTec.text != state.customerEntity?.birthday) {
                        birthdayTec.text = state.customerEntity?.birthday ?? '';
                      }
                      return BaseContainer(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(sp8),
                          child: Form(
                            key: myBloc.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppInput(
                                  initialValue:
                                      state.customerEntity?.fullName ?? '',
                                  label: 'Tên khách hàng',
                                  required: true,
                                  hintText: 'Nhập tên khách hàng',
                                  validate: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Vui long nhập tên khách hàng';
                                    }
                                  },
                                  onChanged: (value) =>
                                      myBloc.updateFieldCustomer(name: value),
                                ),
                                const SizedBox(height: sp16),
                                AppInput(
                                  initialValue:
                                      state.customerEntity?.phone ?? '',
                                  label: 'Số điện thoại',
                                  required: true,
                                  hintText: 'Nhập số điện thoại',
                                  validate: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Vui lòng nhập số điện thoại khách hàng';
                                    } else if (!isPhoneNumberValid(
                                        value ?? '')) {
                                      return 'Vui lòng nhập đúng số điện thoại';
                                    }
                                  },
                                  textInputType: TextInputType.phone,
                                  onChanged: (value) =>
                                      myBloc.updateFieldCustomer(phone: value),
                                ),
                                const SizedBox(height: sp16),
                                CommonDropdown(
                                  label: 'Giới tính',
                                  items: getIt
                                      .get<CustomerCreateCubit>()
                                      .listGender,
                                  hintText: 'Chọn giới tính',
                                  value: state.customerEntity?.gender ?? 1,
                                  onChanged: (value) => myBloc
                                      .updateFieldCustomer(gender: value ?? 1),
                                ),
                                const SizedBox(height: sp16),
                                AppInput(
                                  initialValue:
                                      state.customerEntity?.address?.address ??
                                          '',
                                  label: 'Địa chỉ',
                                  hintText: 'Nhập địa chỉ',
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   isScrollControlled: true,
                                    //   builder: (context) {
                                    //     return Padding(
                                    //       padding: EdgeInsets.only(
                                    //         bottom: MediaQuery.of(context)
                                    //             .viewInsets
                                    //             .bottom,
                                    //       ),
                                    //       child: AddressWidget(
                                    //         onDone: (value) async {
                                    //           final store =
                                    //               state.store!.copyWith(
                                    //             address: AddressEntity(
                                    //               lat: value.lat,
                                    //               long: value.long,
                                    //               address: value.title,
                                    //             ),
                                    //           );
                                    //           _addressPayload = value;
                                    //           emit(
                                    //               state.copyWith(store: store));
                                    //         },
                                    //       ),
                                    //     );
                                    //   },
                                    // );
                                  },
                                  validate: (value) {},
                                  onChanged: (value) => myBloc
                                      .updateFieldCustomer(address: value),
                                ),
                                const SizedBox(height: sp16),
                                AppInput(
                                  initialValue:
                                      state.customerEntity?.email ?? '',
                                  label: 'Email',
                                  hintText: 'Nhập địa chỉ Email',
                                  validate: (value) {
                                    if ((value ?? '').isNotEmpty &&
                                        !isEmailValid(value ?? '')) {
                                      return 'Vui lòng điền đúng định dạng email';
                                    }
                                  },
                                  onChanged: (value) =>
                                      myBloc.updateFieldCustomer(email: value),
                                ),
                                const SizedBox(height: sp16),
                                AppInput(
                                  controller: birthdayTec,
                                  label: 'Ngày sinh',
                                  hintText: 'Chọn ngày sinh',
                                  validate: (value) {},
                                  readOnly: true,
                                  suffixIcon: const Icon(
                                    Icons.calendar_month,
                                    color: greyColor,
                                    size: sp16,
                                  ),
                                  onTap: () async {
                                    final res = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (res != null) {
                                      myBloc.updateFieldCustomer(
                                        birthday:
                                            DateFormat('dd/MM/y').format(res),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: whiteColor,
            padding: const EdgeInsets.all(sp16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Extrabutton(
                    title: 'Huỷ bỏ',
                    event: () => context.router.pop(),
                    largeButton: true,
                    borderColor: borderColor_2,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                Expanded(
                  flex: 1,
                  child: MainButton(
                    title: 'Lưu',
                    event: () => myBloc.editCustomer(context),
                    largeButton: true,
                    icon: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
