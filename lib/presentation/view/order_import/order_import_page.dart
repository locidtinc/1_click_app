import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/bottom_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/order_preview_card.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/utils/dismiss_keyboard.dart';

import 'cubit/order_import_cubit.dart';
import 'cubit/order_import_state.dart';

@RoutePage()
class OrderImportPage extends StatefulWidget {
  const OrderImportPage({super.key});

  @override
  State<OrderImportPage> createState() => _OrderImportPageState();
}

class _OrderImportPageState extends State<OrderImportPage> {
  final myBloc = getIt.get<OrderImportCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderImportCubit>(
      create: (context) => myBloc,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => AppUtils.dissmissKeyboard(),
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(
            title: 'Danh sách đơn đặt hàng',
            // leading: InkWell(
            //   onTap: () => context.router.replace(HomeRoute()),
            //   child: const BackButtonIcon(),
            // ),
          ),
          body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16)
                    .copyWith(bottom: 0),
            child: RefreshIndicator(
              onRefresh: () async {
                myBloc.infiniteListController.onRefresh();
              },
              child: SingleChildScrollView(
                controller: myBloc.scrollController,
                // physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: widthDevice(context),
                      child: MainButton(
                        title: 'Tạo mới đơn đặt hàng',
                        event: () => context.router
                            .push(OrderCreateRoute(typeOrder: TypeOrder.ad)),
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                    const SizedBox(height: sp24),
                    AppInput(
                      hintText: 'Nhập tên, mã đơn hàng',
                      validate: (value) => null,
                      backgroundColor: whiteColor,
                      onChanged: (value) => myBloc.searchKeyChange(value),
                      suffixIcon: const Icon(
                        Icons.search,
                        size: sp16,
                        color: greyColor,
                      ),
                    ),
                    const SizedBox(height: sp24),
                    BlocBuilder<OrderImportCubit, OrderImportState>(
                      builder: (context, state) {
                        return FilterButton(
                          state.listFilter,
                          state.selectFilter,
                          (value) => myBloc.selectFilterButton(value),
                        );
                      },
                    ),
                    const SizedBox(height: sp24),
                    InfiniteList<OrderPreviewEntity>(
                      shrinkWrap: true,
                      getData: (page) => myBloc.getList(page),
                      itemBuilder: (context, item, index) {
                        return OrderPreviewCard(item: item);
                      },
                      scrollController: myBloc.scrollController,
                      infiniteListController: myBloc.infiniteListController,
                      circularProgressIndicator: const BaseLoading(),
                      noItemFoundWidget: const EmptyContainer(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const BuildBottomBar(
            pageCode: TabCode.another,
          ),
        ),
      ),
    );
  }
}
