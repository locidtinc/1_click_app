import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/home/cubit/home_cubit.dart';
import 'package:one_click/presentation/view/store_information/cubit/store_information_cubit.dart';
import 'package:one_click/presentation/view/store_information/cubit/store_information_state.dart';
import 'package:one_click/presentation/view/store_information/widgets/bussiness_address.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_address.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_avatar.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_bank.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_business_info.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';
import 'package:one_click/shared/ext/index.dart';

import 'widgets/store_referent.dart';

@RoutePage()
class StoreInformationPage extends StatelessWidget {
  const StoreInformationPage({Key? key, this.myBloc}) : super(key: key);
  final HomeCubit? myBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Thông tin cửa hàng',
      ),
      backgroundColor: borderColor_1,
      body: BlocProvider<StoreInformationCubit>(
        create: (context) => getIt.get<StoreInformationCubit>()..getStoreInfo(),
        child: BlocListener<StoreInformationCubit, StoreInformationState>(
          listenWhen: (previous, current) =>
              previous.storeEntity != current.storeEntity,
          listener: (context, state) {
            myBloc?.getStoreInfo();
          },
          child: BlocBuilder<StoreInformationCubit, StoreInformationState>(
            builder: (context, state) {
              final bloc = context.read<StoreInformationCubit>();
              if (bloc.isLoading) {
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
                          const SizedBox(height: sp16),
                          StoreAvatar(
                            cubit: bloc,
                          ),
                          StoreGeneralInfo(store: state.storeEntity),
                          const SizedBox(height: sp16),
                          StoreBusinessInfo(store: state.storeEntity),
                          const SizedBox(height: sp16),
                          StoreReferentInfo(store: state.storeEntity),
                          const SizedBox(height: sp24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Extrabutton(
                              title: 'Đổi mật khẩu',
                              event: () => context.router
                                  .push(const ChangePasswordRoute()),
                              largeButton: true,
                              icon: const SizedBox(),
                              borderColor: borderColor_2,
                              bgColor: whiteColor,
                            ),
                          ),
                          const SizedBox(height: sp24),
                          StoreAddress(store: state.storeEntity),
                          StoreBank(
                            card: state.storeEntity.cardData,
                            onTapAddBank: () => bloc.onTapAddBank(context),
                          ),
                          if (state.storeEntity.businessType?.id != 3)
                            16.height,
                          if (state.storeEntity.businessType?.id != 3)
                            BussinessAddress(
                              store: state.storeEntity,
                            ),
                          if (state.storeEntity.businessType?.id != 3)
                            16.height,
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            margin: const EdgeInsets.symmetric(horizontal: 16) +
                                const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                ItemRow(
                                  title: 'Loại hình kinh doanh',
                                  value: state.storeEntity.businessType?.title,
                                  titleStyle: p4.copyWith(color: borderColor_4),
                                ),
                                const SizedBox(height: 16),
                                ItemRow(
                                  title: 'Giờ mở cửa - đóng cửa',
                                  value: state.storeEntity.openTime != null &&
                                          state.storeEntity.openTime!
                                              .isNotEmpty &&
                                          state.storeEntity.closeTime != null &&
                                          state
                                              .storeEntity.closeTime!.isNotEmpty
                                      ? '${state.storeEntity.openTime} - ${state.storeEntity.closeTime}'
                                      : '',
                                  titleStyle: p4.copyWith(color: borderColor_4),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   padding: const EdgeInsets.all(24),
                          //   margin: const EdgeInsets.symmetric(horizontal: 16) + const EdgeInsets.only(top: 16),
                          //   decoration: BoxDecoration(
                          //     color: whiteColor,
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: state.storeEntity.description != null && state.storeEntity.description!.isNotEmpty
                          //       ? Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               'Mô tả',
                          //               style: p4.copyWith(color: borderColor_4),
                          //             ),
                          //             const SizedBox(height: 16),
                          //             Text(
                          //               state.storeEntity.description!,
                          //               style: p4,
                          //             ),
                          //           ],
                          //         )
                          //       : Center(
                          //           child: Text(
                          //             'Chưa có mô tả nào',
                          //             style: p4.copyWith(color: borderColor_4),
                          //           ),
                          //         ),
                          // ),
                          const SizedBox(height: sp24),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: sp16),
                            child: Extrabutton(
                              title: 'Đăng xuất khỏi tài khoản',
                              event: () => bloc.logout(context),
                              largeButton: true,
                              borderColor: borderColor_2,
                              icon: const Icon(
                                Icons.logout_rounded,
                                size: sp16,
                                color: blackColor,
                              ),
                              bgColor: whiteColor,
                            ),
                          ),
                          const SizedBox(height: sp24),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: sp16),
                            child: SupportButton(
                              title: 'Vô hiệu tài khoản',
                              event: () => bloc.deleteAccount(context),
                              largeButton: true,
                              icon: null,
                              backgroundColor: whiteColor,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: sp24),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16) +
                        const EdgeInsets.only(top: 16) +
                        const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, -10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Extrabutton(
                      title: 'Chỉnh sửa thông tin',
                      event: () =>
                          bloc.onTapEditStore(context, state.storeEntity),
                      largeButton: true,
                      icon: const SizedBox(),
                      borderColor: borderColor_2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
