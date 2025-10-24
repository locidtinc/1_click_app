import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/card/brand_card.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_cubit.dart';

import 'cubit/category_state.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final myBloc = getIt.get<CategoryCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // myBloc.infiniteListController.onRefresh(); // Gọi API khi quay lại màn hình
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
      create: (context) => myBloc,
      child: BlocListener<CategoryCubit, CategoryState>(
        listener: (context, state) {
          myBloc.infiniteListController.onRefresh();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            myBloc.infiniteListController.onRefresh();
          },
          child: SingleChildScrollView(
            controller: myBloc.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const Divider(height: 1, color: borderColor_1, thickness: 1),
                Container(
                  color: whiteColor,
                  padding: const EdgeInsets.all(sp16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Danh mục',
                            style: p7.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: sp12),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              return Text(
                                state.optionsSelected.value,
                                style: p5,
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => myBloc.isOpenPopChange(),
                        child: Container(
                          padding: const EdgeInsets.all(sp12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp8),
                            color: borderColor_1,
                          ),
                          child: Center(
                            child: BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return Icon(
                                  state.isOpenPop ? Icons.close : Icons.menu,
                                  size: sp16,
                                  color: blackColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: sp24,
                        horizontal: sp16,
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                child: MainButton(
                                  title: 'Tạo ${state.optionsSelected.value}',
                                  event: () async {
                                    final result = await context.router
                                        .push(state.optionsSelected.routerPage);
                                    if (result is bool && result == true) {
                                      myBloc.infiniteListController.onRefresh();
                                    }
                                  },
                                  largeButton: true,
                                  icon: null,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: sp24),
                          AppInput(
                            hintText: 'Tìm kiếm',
                            validate: (value) {},
                            onChanged: (value) => myBloc.searchKeyChange(value),
                            suffixIcon: const Icon(
                              Icons.search,
                              size: sp16,
                              color: greyColor,
                            ),
                            backgroundColor: whiteColor,
                          ),
                          const SizedBox(height: sp24),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              return FilterButton(
                                state.listFilter,
                                state.selectFilter,
                                (value) => myBloc.filterChange(value),
                              );
                            },
                          ),
                          const SizedBox(height: sp24),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              return InfiniteList<BrandEntity>(
                                shrinkWrap: true,
                                getData: (page) {
                                  return myBloc.getListBrand(page);
                                },
                                itemBuilder: (context, item, index) {
                                  return BrandCard(
                                    item: item,
                                    typeCategory: state.optionsSelected,
                                    onTap: () =>
                                        myBloc.onTapItem(context, item.id ?? 0),
                                    onTapDelete: () {
                                      myBloc.onTapDelete(context, item.id ?? 0);
                                    },
                                  );
                                },
                                scrollController: myBloc.scrollController,
                                infiniteListController:
                                    myBloc.infiniteListController,
                                circularProgressIndicator: const BaseLoading(),
                                noItemFoundWidget: const EmptyContainer(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        return Visibility(
                          visible: state.isOpenPop,
                          child: Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(sp16),
                              color: blackColor.withOpacity(0.8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chọn danh mục khác',
                                    style: p5.copyWith(color: whiteColor),
                                  ),
                                  Column(
                                    children: state.listOptions
                                        .where(
                                          (e) => e != state.optionsSelected,
                                        )
                                        .map(
                                          (e) => GestureDetector(
                                            onTap: () => myBloc.optionChange(e),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: sp16,
                                              ),
                                              child: BaseContainer(
                                                context,
                                                Text(e.value, style: p5),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
