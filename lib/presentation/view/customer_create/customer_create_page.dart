import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

import '../authen/components/choose_address.dart';
import '../authen/models/confirm_account_payload.dart';
import 'cubit/customer_create_cubit.dart';
import 'cubit/customer_create_state.dart';

@RoutePage()
class CustomerCreatePage extends StatefulWidget {
  const CustomerCreatePage({super.key});

  @override
  State<CustomerCreatePage> createState() => _CustomerCreatePageState();
}

class _CustomerCreatePageState extends State<CustomerCreatePage> {
  final myBloc = getIt.get<CustomerCreateCubit>();

  AddressDataPayload? get address => myBloc.state.addressPayload;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerCreateCubit>(
      create: (context) => myBloc,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(title: 'Tạo mới khách hàng'),
          body: Form(
            key: myBloc.formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  BlocBuilder<CustomerCreateCubit, CustomerCreateState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: state.avatar == null
                                  ? const NetworkImage(PrefKeys.avatarDefault)
                                  : FileImage(state.avatar!)
                                      as ImageProvider<Object>?,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => myBloc.avatarCustomerPicker(),
                              child: const CircleAvatar(
                                radius: sp12,
                                backgroundColor: mainColor,
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: whiteColor,
                                    size: sp12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: sp24),
                  BaseContainer(
                    context,
                    Padding(
                      padding: const EdgeInsets.all(sp8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppInput(
                            label: 'Tên khách hàng',
                            required: true,
                            hintText: 'Nhập tên khách hàng',
                            validate: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Vui long nhập tên khách hàng';
                              }
                            },
                            onChanged: (value) => myBloc.fullNameChange(value),
                          ),
                          const SizedBox(height: sp16),
                          AppInput(
                            label: 'Số điện thoại',
                            required: true,
                            hintText: 'Nhập số điện thoại',
                            validate: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Vui lòng nhập số điện thoại khách hàng';
                              } else if (!isPhoneNumberValid(value ?? '')) {
                                return 'Vui lòng nhập đúng số điện thoại';
                              }
                            },
                            textInputType: TextInputType.phone,
                            onChanged: (value) => myBloc.phoneChange(value),
                          ),
                          const SizedBox(height: sp16),
                          CommonDropdown(
                            label: 'Giới tính',
                            items: myBloc.listGender,
                            hintText: 'Chọn giới tính',
                            onChanged: (value) =>
                                myBloc.genderChange(value ?? 1),
                          ),
                          // const SizedBox(height: sp16),
                          // AppInput(
                          //   label: 'Địa chỉ',
                          //   hintText: 'Nhập địa chỉ',
                          //   validate: (value) {},
                          //   onChanged: (value) => myBloc.addressChange(value),
                          // ),
                          const SizedBox(height: sp16),
                          AppInput(
                            label: 'Email',
                            hintText: 'Nhập địa chỉ Email',
                            validate: (value) {
                              if ((value ?? '').isNotEmpty &&
                                  !isEmailValid(value ?? '')) {
                                return 'Vui lòng điền đúng định dạng email';
                              }
                            },
                            onChanged: (value) => myBloc.emailChange(value),
                          ),
                          const SizedBox(height: sp16),
                          BlocBuilder<CustomerCreateCubit, CustomerCreateState>(
                            buildWhen: (previous, current) =>
                                previous.birthday != current.birthday,
                            builder: (context, state) {
                              return AppInput(
                                initialValue: state.birthday,
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
                                    myBloc.birthdayChange(
                                      DateFormat('dd/MM/y').format(res),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<CustomerCreateCubit, CustomerCreateState>(
                    builder: (context, state) {
                      return FormField(
                        // validator: (value) {
                        //   if (address?.province == null) {
                        //     return 'Không bỏ trống';
                        //   }
                        //   return null;
                        // },
                        builder: (field) {
                          return ChooseAddress(
                            errorText: field.errorText,
                            address: address,
                            bg: Colors.white,
                            onTap: () {
                              context
                                  .pushRoute(
                                AddressV2Route(
                                  address: address,
                                ),
                              )
                                  .then((value) {
                                if (value is AddressDataPayload) {
                                  myBloc.updateAddress(value);
                                }
                              });
                            },
                          );
                        },
                      ).padding(16.pading);
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
                    title: 'Tạo mới',
                    event: () => myBloc.createCustomer(context),
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
