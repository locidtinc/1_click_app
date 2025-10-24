import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/product_added_card.dart';
import 'package:one_click/presentation/view/group_edit/cubit/group_edit_cubit.dart';
import 'package:one_click/presentation/view/group_edit/cubit/group_edit_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@RoutePage()
class GroupEditPage extends StatelessWidget {
  const GroupEditPage({super.key, this.groups});

  final GroupDetailEntity? groups;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Chỉnh sửa nhóm sản phẩm'),
      backgroundColor: bg_4,
      body: BlocProvider<GroupEditCubit>(
        create: (context) {
          return getIt.get<GroupEditCubit>()..getCategory(groups);
        },
        child: BlocBuilder<GroupEditCubit, GroupEditState>(
          builder: (context, state) {
            final myBloc = context.read<GroupEditCubit>();
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
                        const SizedBox(height: sp24),
                        CardBase(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thông tin nhóm sản phẩm',
                                style: p1.copyWith(color: blackColor),
                              ),
                              const SizedBox(height: sp24),
                              AppInput(
                                label: 'Tên nhóm sản phẩm',
                                hintText: 'Nhập tên nhóm sản phẩm',
                                validate: (value) {},
                                initialValue: state.groups?.title,
                                onChanged: (value) => myBloc.titleChange(value),
                              ),
                              const SizedBox(height: sp16),
                              CommonDropdown(
                                label: 'Ngành hàng',
                                items: state.listCategory,
                                hintText: 'Chọn ngành hàng',
                                value: state.productCategory,
                                onChanged: (value) =>
                                    myBloc.productCategoryChange(value ?? 1),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: sp16,
                            vertical: sp24,
                          ),
                          child: Text(
                            'Danh sách sản phẩm',
                            style: p1,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: sp16),
                          child: MainButton(
                            title: 'Thêm sản phẩm',
                            event: () => context.router.push(
                              AddProductRoute(
                                onConfirm: (value) =>
                                    myBloc.updateProduct(value),
                                listProductInit: state.groups?.products ?? [],
                              ),
                            ),
                            largeButton: true,
                            icon: null,
                          ),
                        ),
                        const SizedBox(height: sp16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: sp16),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final product = state.groups?.products[index];
                              return ProductAddedCard(
                                deleteProduct: (product) =>
                                    myBloc.deleteProduct(product),
                                product: product!,
                                isDelete: state.groups?.account == userId,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: sp16,
                            ),
                            itemCount: state.groups!.products.length,
                          ),
                        ),
                        const SizedBox(height: sp24)
                      ],
                    ),
                  ),
                ),
                TwoButtonBox(
                  extraTitle: 'Huỷ',
                  mainTitle: 'Lưu',
                  extraOnTap: () => myBloc.onTapCancel(context),
                  mainOnTap: () => myBloc.onTapSave(context),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
