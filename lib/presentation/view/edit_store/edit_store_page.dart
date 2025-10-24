import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/business_type_widget.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/widget/chip_custom.dart';
import 'package:one_click/presentation/view/edit_store/cubit/edit_store_cubit.dart';
import 'package:one_click/presentation/view/edit_store/cubit/edit_store_state.dart';
import 'package:one_click/presentation/view/store_information/widgets/bussiness_address.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_address.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_bank.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';
import 'package:one_click/shared/ext/index.dart';

@RoutePage()
class EditStorePage extends StatelessWidget {
  const EditStorePage({super.key, required this.store});

  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Chỉnh sửa thông tin cửa hàng',
      ),
      backgroundColor: borderColor_1,
      body: BlocProvider<EditStoreCubit>(
        create: (context) =>
            getIt.get<EditStoreCubit>()..getListBusinessType(store),
        child: BlocBuilder<EditStoreCubit, EditStoreState>(
          builder: (context, state) {
            final bloc = context.read<EditStoreCubit>();
            final isCheckId = state.businessType ?? store.business;
            if (state.isLoading) {
              return const Center(
                child: BaseLoading(),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            children: [
                              ItemRow(
                                title: 'Mã cửa hàng',
                                value: store.storeCode,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                              ItemRow(
                                title: 'Số điện thoại',
                                value: store.phoneNumber,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                              const SizedBox(height: sp8),
                              AppInput(
                                label: 'Tên cửa hàng',
                                hintText: 'Nhập tên cửa hàng',
                                initialValue: store.nameStore,
                                labelStyle: p4.copyWith(color: borderColor_4),
                                validate: (String? value) {},
                                onChanged: bloc.onChangeStoreName,
                              ),
                              // const SizedBox(height: sp16),
                              // AppInput(
                              //   label: 'Số điện thoại',
                              //   hintText: 'Nhập số điện thoại',
                              //   initialValue: store.phoneNumber,
                              //   labelStyle: p4.copyWith(color: borderColor_4),
                              //   textInputType: TextInputType.phone,
                              //   validate: (String? value) {},
                              //   onChanged: bloc.onChangePhoneNumber,
                              // ),

                              // const SizedBox(height: sp8),
                              // ItemRow(
                              //   title: 'Website',
                              //   value: store.website,
                              //   isWebsite: true,
                              //   titleStyle: p4.copyWith(color: borderColor_4),
                              // ),
                              const SizedBox(height: sp8),
                              AppInput(
                                label: 'Website',
                                hintText: 'Nhập Website (không kí tự và dấu)',
                                initialValue: store.website,
                                labelStyle: p4.copyWith(color: borderColor_4),
                                validate: (String? value) {},
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9\-.:/]'),
                                  ),
                                ],
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '1click.vn',
                                    style: p6.copyWith(
                                      color: borderColor_4,
                                    ),
                                  ),
                                ),
                                onChanged: bloc.onChangeWebsite,
                              ),

                              // const SizedBox(height: sp12),
                              // AppInput(
                              //   label: 'Người liên hệ',
                              //   hintText: 'Nhập tên người liên hệ',
                              //   initialValue: store.contact,
                              //   labelStyle: p4.copyWith(color: borderColor_4),
                              //   validate: (String? value) {},
                              //   onChanged: bloc.onChangeContact,
                              // ),
                              // const SizedBox(height: sp16),
                              // AppInput(
                              //   label: 'Email',
                              //   hintText: 'Nhập email',
                              //   initialValue: store.email,
                              //   labelStyle: p4.copyWith(color: borderColor_4),
                              //   validate: (String? value) {},
                              //   onChanged: bloc.onChangeEmail,
                              // ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        StoreAddress(
                          store: state.store!,
                          onTapEditAddress: () =>
                              bloc.onTapAddressShop(context),
                        ),
                        StoreBank(
                          card: state.store!.cardData,
                          onTapEditBank: () => bloc.onTapEditBank(context),
                          onTapAddBank: () => bloc.onTapAddBank(context),
                        ),
                        const SizedBox(height: 16),
                        BusinessTypeWidget(
                          businessType: state.business,
                          openTime: state.openTime,
                          closeTime: state.closeTime,
                          onChangeOpenTime: () =>
                              bloc.onChangeOpenTime(context),
                          onChangeCloseTime: () =>
                              bloc.onChangeCloseTime(context),
                          onTap: () => bloc.onSelectBusinessType(context),
                        ),
                        if (isCheckId != 3) const SizedBox(height: 16),
                        if (isCheckId != 3)
                          BussinessAddress(
                            store: state.store!,
                            onTapEditAddress: () =>
                                bloc.onTapEditAddress(context),
                          ),
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            children: [
                              AppInput(
                                label: 'Người đại diện',
                                hintText: 'Nhập tên người đại diện',
                                initialValue: store.deputyName,
                                labelStyle: p4.copyWith(color: borderColor_4),
                                validate: (String? value) {},
                                onChanged: bloc.onChangeDeputy,
                              ),
                              const SizedBox(height: sp8),
                              if (isCheckId != 3)
                                AppInput(
                                  label: 'Mã số thuế',
                                  hintText: 'Nhập mã số thuế',
                                  initialValue: store.taxCode,
                                  labelStyle: p4.copyWith(color: borderColor_4),
                                  validate: (String? value) {},
                                  onChanged: bloc.onChangeTaxCode,
                                ),
                              const SizedBox(height: sp8),
                              if (isCheckId != 3)
                                AppInput(
                                  label: 'Mã kinh doanh',
                                  hintText: 'Nhập mã kinh doanh',
                                  initialValue: store.businessCode,
                                  labelStyle: p4.copyWith(color: borderColor_4),
                                  validate: (String? value) {},
                                  onChanged: bloc.onChangeBusinesssCode,
                                ),
                              if (isCheckId != 3) const SizedBox(height: sp8),
                              AppInput(
                                label: 'Diện tích kho (m²)',
                                hintText: 'Nhập diện tích kho',
                                initialValue: store.warehouseArea,
                                labelStyle: p4.copyWith(color: borderColor_4),
                                validate: (String? value) {},
                                onChanged: bloc.onChangeWareHouseArena,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Column(
                          children: [
                            CardBase(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: sp16) +
                                      const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Column(
                                children: [
                                  state.isCheckReferralCode == false
                                      ? ItemRow(
                                          title: 'Mã giới thiệu',
                                          value: store.referralCode,
                                          titleStyle:
                                              p4.copyWith(color: borderColor_4),
                                        )
                                      : AppInput(
                                          label:
                                              'Mã giới thiệu (Chỉ chỉnh sửa 1 lần) ',
                                          hintText: 'Nhập mã giới thiệu',
                                          initialValue: store.referralCode,
                                          labelStyle:
                                              p4.copyWith(color: borderColor_4),
                                          validate: (String? value) {},
                                          onChanged: bloc.onreferralCode,
                                        ),
                                  const SizedBox(height: sp8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ChipCustom(
                                        color: AppColors
                                            .button_neutral_alpha_textDefault,
                                        isBorder: false,
                                        title: 'Chỉnh sửa',
                                        padding: 12.padingHor + 6.padingVer,
                                        onTap: () {
                                          bloc.isCheck(
                                              !state.isCheckReferralCode!);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // CardBase(
                        //   child: AppInput(
                        //     label: 'Mô tả',
                        //     hintText: 'Nhập mô tả',
                        //     initialValue: store.description,
                        //     validate: (String? value) {},
                        //     onChanged: bloc.onChangeDescription,
                        //   ),
                        // ),
                        // const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                TwoButtonBox(
                  extraTitle: 'Huỷ bỏ',
                  mainTitle: 'Lưu lại',
                  extraOnTap: () => bloc.onTapCancel(context),
                  mainOnTap: () => bloc.onTapSave(context, store),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
