import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/business_type_widget.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/additional_information/cubit/additional_information_cubit.dart';
import 'package:one_click/presentation/view/additional_information/cubit/additional_information_state.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_bank.dart';

@RoutePage()
class AdditionalInformationPage extends StatelessWidget {
  const AdditionalInformationPage({
    super.key,
    required this.store,
    required this.token,
  });

  final StoreEntity store;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Thông tin bổ sung',
      ),
      backgroundColor: borderColor_1,
      body: BlocProvider<AdditionalInformationCubit>(
        create: (context) =>
            getIt.get<AdditionalInformationCubit>()..getListBusinessType(token),
        child:
            BlocBuilder<AdditionalInformationCubit, AdditionalInformationState>(
          builder: (context, state) {
            final bloc = context.read<AdditionalInformationCubit>();
            if (state.isLoading) {
              return const BaseLoading();
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: sp24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppInput(
                                label: 'Email',
                                hintText: 'Nhập email',
                                textInputType: TextInputType.emailAddress,
                                validate: bloc.validateEmail,
                                onChanged: bloc.onChangeEmail,
                              ),
                              const SizedBox(height: sp4),
                              Text(
                                'Email sẽ dùng để cấp lại mật khẩu',
                                style: p7.copyWith(color: yellow_1),
                              ),
                              // const SizedBox(height: sp16),
                              // AppInput(
                              //   label: 'Người đại diện',
                              //   hintText: 'Nhập têm người đại diện',
                              //   validate: (String? value) {},
                              //   onChanged: bloc.onChangeDeputy,
                              // ),
                              const SizedBox(height: sp16),
                              AppInput(
                                label: 'Người liên hệ',
                                hintText: 'Nhập tên người liên hệ',
                                validate: (String? value) {},
                                onChanged: bloc.onChangeContact,
                              ),
                            ],
                          ),
                        ),
                        StoreBank(
                          card: state.cardData,
                          onTapAddBank: () => bloc.onTapAddBank(context, token),
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
                        const SizedBox(height: 16),
                        CardBase(
                          child: AppInput(
                            label: 'Mã giới thiệu',
                            hintText: 'Nhập mã giới thiệu',
                            validate: (String? value) {},
                            onChanged: bloc.onChangeReferralCode,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CardBase(
                          child: AppInput(
                            label: 'Mô tả',
                            hintText: 'Nhập mô tả',
                            validate: (String? value) {},
                            onChanged: bloc.onChangeDescription,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                TwoButtonBox(
                  extraTitle: 'Bỏ qua',
                  mainTitle: 'Xác nhận',
                  extraOnTap: () => bloc.onTapSkip(context),
                  mainOnTap: () => bloc.onTapConfirm(context, store, token),
                  isDisable: state.enableButton,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
