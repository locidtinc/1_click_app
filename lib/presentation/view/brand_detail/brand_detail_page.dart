import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/card/product_preview_card.dart';
import 'package:one_click/presentation/shared_view/widget/row_item.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import 'cubit/brand_detail_cubit.dart';
import 'cubit/brand_detail_state.dart';

@RoutePage()
class BrandDetailPage extends StatelessWidget {
  const BrandDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandDetailCubit>(
      create: (_) => getIt.get<BrandDetailCubit>()..getBrandDetail(id),
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'Chi tiết thương hiệu'),
        body: BlocBuilder<BrandDetailCubit, BrandDetailState>(
          builder: (context, state) {
            final myBloc = context.read<BrandDetailCubit>();
            final userId = AppSharedPreference.instance.getValue(PrefKeys.user);
            if (myBloc.isLoading) {
              return const BaseLoading();
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: 16) +
                              const EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor_2),
                                  borderRadius: BorderRadius.circular(sp8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(sp8),
                                  child: Image.network(
                                    state.brandDetail.image ??
                                        PrefKeys.imgProductDefault,
                                  ),
                                ),
                              ),
                              const SizedBox(height: sp20),
                              RowItem(
                                title: 'Tên thương hiệu',
                                content: state.brandDetail.title,
                              ),
                              const SizedBox(height: sp16),
                              const Divider(height: 1, color: greyColor),
                              const SizedBox(height: sp16),
                              RowItem(
                                title: 'Phân loại',
                                content: (state.brandDetail.isSystem)
                                    ? 'MyKios'
                                    : 'Nội bộ',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: sp24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Danh sách sản phẩm',
                                style: p1.copyWith(color: blackColor),
                              ),
                              const SizedBox(height: sp24),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final product =
                                      state.brandDetail.products[index];
                                  return ProductPreviewCard(item: product);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: sp16),
                                itemCount: state.brandDetail.products.length,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: sp24),
                        if (state.brandDetail.account == userId)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: sp16),
                            width: double.infinity,
                            child: SupportButton(
                              title: 'Xoá thương hiệu',
                              event: () => myBloc.onTapDeleteBrand(context, id),
                              icon: null,
                              largeButton: true,
                              backgroundColor: whiteColor,
                              color: mainColor,
                            ),
                          ),
                        const SizedBox(height: sp24),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<BrandDetailCubit, BrandDetailState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: !state.brandDetail.isAdminCreated,
                      child: Container(
                        padding: const EdgeInsets.all(sp16),
                        width: double.infinity,
                        color: whiteColor,
                        child: Extrabutton(
                          title: 'Chỉnh sửa thông tin thương hiệu',
                          event: () => myBloc.onTapEditBrand(context),
                          largeButton: true,
                          borderColor: borderColor_2,
                          icon: null,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
