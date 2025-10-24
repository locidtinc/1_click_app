import 'package:auto_route/annotations.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/category_detail/cubit/category_detail_cubit.dart';
import 'package:one_click/presentation/view/category_detail/cubit/category_detail_state.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@RoutePage()
class CategoryDetailPage extends StatelessWidget {
  const CategoryDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Chi tiết ngành hàng',
      ),
      backgroundColor: bg_4,
      body: BlocProvider<CategoryDetailCubit>(
        create: (_) =>
            getIt.get<CategoryDetailCubit>()..getProductCategoryDetail(id),
        child: BlocBuilder<CategoryDetailCubit, CategoryDetailState>(
          builder: (context, state) {
            final bloc = context.read<CategoryDetailCubit>();
            final userId = AppSharedPreference.instance.getValue(PrefKeys.user);
            if (bloc.isLoading) {
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
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: sp24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: sp16,
                            vertical: sp8,
                          ),
                          child: Column(
                            children: [
                              ItemRow(
                                title: 'Ngành hàng',
                                value: state.category.title,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                              const SizedBox(height: sp8),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: borderColor_2,
                              ),
                              const SizedBox(height: sp8),
                              ItemRow(
                                title: 'Phân loại',
                                value: state.category.isSystem
                                    ? 'Nội bộ'
                                    : 'My Kiot',
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(sp16),
                          child: Text(
                            'Danh sách nhóm sản phẩm',
                            style: p1,
                          ),
                        ),
                        state.category.groups.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: sp16,
                                ),
                                child: Text(
                                  'Chưa có nhóm sản phẩm nào',
                                  style: p6.copyWith(color: borderColor_4),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return CardBase(
                                    padding: const EdgeInsets.all(sp16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.category.groups[index].title,
                                          style: p3,
                                        ),
                                        const SizedBox(height: sp8),
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                '${state.category.groups[index].code} - ',
                                            style: p4.copyWith(
                                              color: borderColor_4,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${state.category.groups[index].productQuantity} sản phẩm',
                                                style: p3.copyWith(
                                                  color: borderColor_4,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: sp16);
                                },
                                itemCount: state.category.groups.length,
                              ),
                        if (state.category.account == userId)
                          Container(
                            padding: const EdgeInsets.all(sp16),
                            width: double.infinity,
                            child: SupportButton(
                              title: 'Xoá ngành hàng',
                              event: () => bloc.onTapDeleteCategory(context),
                              icon: null,
                              largeButton: true,
                              backgroundColor: whiteColor,
                              color: mainColor,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CategoryDetailCubit, CategoryDetailState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: !state.category.isSystem,
                      child: Container(
                        padding: const EdgeInsets.all(sp16),
                        color: whiteColor,
                        child: SizedBox(
                          width: double.infinity,
                          child: Extrabutton(
                            title: 'Chỉnh sửa thông tin ngành hàng',
                            event: () => bloc.onTapEditCategory(context),
                            largeButton: true,
                            borderColor: borderColor_2,
                            icon: null,
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
