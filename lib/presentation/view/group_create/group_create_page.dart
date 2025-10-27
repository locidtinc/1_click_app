import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/product_added_card.dart';

import 'cubit/group_create_cubit.dart';
import 'cubit/group_create_state.dart';

@RoutePage()
class GroupCreatePage extends StatefulWidget {
  const GroupCreatePage({Key? key}) : super(key: key);

  @override
  State<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
  final nameCategoryTec = TextEditingController();
  @override
  void dispose() {
    nameCategoryTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupCreateCubit>(
      create: (context) => getIt.get<GroupCreateCubit>()..getCategory(),
      child: BlocBuilder<GroupCreateCubit, GroupCreateState>(
        builder: (context, state) {
          if (nameCategoryTec.text != state.title) {
            nameCategoryTec.text = '';
          }
          final myBloc = context.read<GroupCreateCubit>();
          return Scaffold(
            backgroundColor: bg_4,
            appBar: const BaseAppBar(title: 'Tạo nhóm sản phẩm'),
            body: Container(
              width: widthDevice(context),
              height: heightDevice(context),
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseContainer(
                      context,
                      Padding(
                        padding: const EdgeInsets.all(sp8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin nhóm sản phẩm',
                              style: p1.copyWith(color: blackColor),
                            ),
                            const SizedBox(height: sp24),
                            AppInput(
                              controller: nameCategoryTec,
                              label: 'Tên nhóm sản phẩm',
                              hintText: 'Nhập tên nhóm sản phẩm',
                              validate: (value) {},
                              onChanged: (value) => myBloc.titleChange(value),
                            ),
                            const SizedBox(height: sp16),
                            CommonDropdown(
                              required: true,
                              label: 'Ngành hàng',
                              items: state.listCategory,
                              hintText: 'Chọn ngành hàng',
                              onChanged: (value) =>
                                  myBloc.productCategoryChange(value ?? 1),
                              value: state.productCategory,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: sp24),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Thêm sản phẩm',
                        event: () => context.router.push(
                          AddProductRoute(
                            onConfirm: (value) => myBloc.updateProduct(value),
                            listProductInit: state.listProduct,
                          ),
                        ),
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                    const SizedBox(height: sp16),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final product = state.listProduct[index];
                        return ProductAddedCard(
                          deleteProduct: (product) =>
                              myBloc.deleteProduct(product),
                          product: product,
                          isDelete: true,
                          warningItem: product.groupName == null
                              ? null
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(sp12),
                                  decoration: BoxDecoration(
                                    color: yellow_2,
                                    borderRadius: BorderRadius.circular(sp8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        '${AssetsPath.icon}/ic_warning.svg',
                                        width: sp12,
                                      ),
                                      const SizedBox(width: sp8),
                                      Text(
                                        'NSP hiện tại',
                                        style: p5.copyWith(color: greyColor),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        child: Text(
                                          '${product.groupName}',
                                          style: p5,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: sp16,
                      ),
                      itemCount: state.listProduct.length,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(sp16),
              color: whiteColor,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Extrabutton(
                      title: 'Lưu và tạo thêm',
                      event: () => myBloc.saveAndCreateMore(context),
                      largeButton: true,
                      borderColor: borderColor_2,
                      icon: null,
                    ),
                  ),
                  const SizedBox(width: sp16),
                  Expanded(
                    child: MainButton(
                      title: 'Lưu',
                      event: () => myBloc.createGroup(context),
                      largeButton: true,
                      icon: null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
