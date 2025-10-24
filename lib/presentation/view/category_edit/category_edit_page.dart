import 'package:auto_route/annotations.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/category_edit/cubit/category_edit_cubit.dart';
import 'package:one_click/presentation/view/category_edit/cubit/category_edit_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@RoutePage()
class CategoryEditPage extends StatelessWidget {
  const CategoryEditPage({super.key, required this.category});

  final CategoryDetailEntity category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Chỉnh sửa thông tin ngành hàng'),
      backgroundColor: bg_4,
      body: BlocProvider<CategoryEditCubit>(
        create: (_) => getIt.get<CategoryEditCubit>()..initData(category),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CardBase(
                      margin: const EdgeInsets.symmetric(horizontal: sp16) +
                          const EdgeInsets.only(top: sp24),
                      child: BlocBuilder<CategoryEditCubit, CategoryEditState>(
                        builder: (context, state) {
                          final userId = AppSharedPreference.instance
                              .getValue(PrefKeys.user);
                          return Form(
                            key: context.read<CategoryEditCubit>().formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thông tin ngành hàng',
                                  style: p1,
                                ),
                                const SizedBox(height: sp24),
                                AppInput(
                                  label: 'Tên ngành hàng',
                                  required: true,
                                  initialValue: state.category?.title,
                                  hintText: 'Nhập tên ngành hàng',
                                  readOnly: state.category?.account != userId,
                                  backgroundColor:
                                      state.category?.account == userId
                                          ? whiteColor
                                          : borderColor_1,
                                  validate: context
                                      .read<CategoryEditCubit>()
                                      .validateCategory,
                                  onChanged: context
                                      .read<CategoryEditCubit>()
                                      .onChangeTitle,
                                ),
                                const SizedBox(height: sp16),
                                Container(
                                  padding: const EdgeInsets.all(sp16),
                                  decoration: BoxDecoration(
                                    color: bg_4,
                                    borderRadius: BorderRadius.circular(sp8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phân loại',
                                        style: p6.copyWith(color: blackColor),
                                      ),
                                      Text(
                                        'Nội bộ',
                                        style: p5.copyWith(color: blackColor),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(sp16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Danh sách nhóm sản phẩm',
                            style: p1,
                          ),
                          const SizedBox(height: sp16),
                          BlocBuilder<CategoryEditCubit, CategoryEditState>(
                            builder: (context, state) => SizedBox(
                              width: double.infinity,
                              child: MainButton(
                                title: 'Tạo nhóm sản phẩm',
                                event: () => context
                                    .read<CategoryEditCubit>()
                                    .onTapCreateGroup(context),
                                largeButton: true,
                                icon: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: sp16),
                        ],
                      ),
                    ),
                    BlocBuilder<CategoryEditCubit, CategoryEditState>(
                      builder: (context, state) {
                        if (state.category != null &&
                            state.category!.groups.isEmpty) {
                          return const SizedBox();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.category!.groups.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = state.category!.groups[index];
                            final userId = AppSharedPreference.instance
                                .getValue(PrefKeys.user);
                            return CardBase(
                              padding: const EdgeInsets.all(sp16),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: sp16) +
                                      const EdgeInsets.only(bottom: sp16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: p3,
                                      ),
                                      const SizedBox(height: sp8),
                                      RichText(
                                        text: TextSpan(
                                          text: '${item.code} - ',
                                          style: p4.copyWith(
                                            color: borderColor_4,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${item.productQuantity} sản phẩm',
                                              style: p3.copyWith(
                                                color: borderColor_4,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.account == userId)
                                    InkWell(
                                      onTap: () => context
                                          .read<CategoryEditCubit>()
                                          .deleteItem(context, index),
                                      child: SvgPicture.asset(
                                        '${AssetsPath.icon}/ic_delete.svg',
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<CategoryEditCubit, CategoryEditState>(
              builder: (context, state) {
                final userId =
                    AppSharedPreference.instance.getValue(PrefKeys.user);
                if (state.category?.account == userId) {
                  return TwoButtonBox(
                    extraTitle: 'Huỷ bỏ',
                    mainTitle: 'Lưu',
                    mainOnTap: () =>
                        context.read<CategoryEditCubit>().onTapSave(context),
                    extraOnTap: () =>
                        context.read<CategoryEditCubit>().onTapCancel(context),
                  );
                }
                return Container(
                  color: whiteColor,
                  padding: const EdgeInsets.all(sp16),
                  width: double.infinity,
                  child: MainButton(
                    title: 'Xong',
                    event: () {},
                    largeButton: true,
                    icon: null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
