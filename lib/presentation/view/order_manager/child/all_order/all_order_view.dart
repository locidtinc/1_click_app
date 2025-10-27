import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/order_preview_card.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/order_manager/child/all_order/cubit/all_order_cubit.dart';
import 'package:one_click/presentation/view/order_manager/child/all_order/cubit/all_order_state.dart';

class AllOrderView extends StatefulWidget {
  const AllOrderView({super.key, required this.isOnline});

  final bool? isOnline;

  @override
  State<AllOrderView> createState() => _AllOrderViewState();
}

class _AllOrderViewState extends State<AllOrderView>
    with AutomaticKeepAliveClientMixin {
  final bloc = getIt.get<AllOrderCubit>();

  @override
  void initState() {
    super.initState();
    bloc.isOnlineChange(widget.isOnline);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<AllOrderCubit>(
      create: (context) => bloc,
      child: BlocBuilder<AllOrderCubit, AllOrderState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              bloc.infiniteListController.onRefresh();
            },
            child: SingleChildScrollView(
              controller: bloc.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      title: 'Tạo mới đơn bán hàng',
                      event: () => context.router.push(OrderCreateRoute(
                        typeOrder: TypeOrder.cHTH,
                        isOnline: widget.isOnline,
                      )),
                      largeButton: true,
                      icon: null,
                    ),
                  ),
                  const SizedBox(height: sp24),
                  AppInput(
                    hintText: 'Tìm kiếm',
                    validate: (value) => null,
                    backgroundColor: whiteColor,
                    suffixIcon: const Icon(
                      Icons.search,
                      size: sp16,
                      color: greyColor,
                    ),
                    onChanged: (value) => bloc.searchKeyChange(value),
                  ),
                  const SizedBox(height: sp24),
                  BlocBuilder<AllOrderCubit, AllOrderState>(
                    builder: (context, state) {
                      return FilterButton(
                        state.listFilter,
                        state.selectFilter,
                        (value) => context
                            .read<AllOrderCubit>()
                            .selectFilterButton(value),
                      );
                    },
                  ),
                  const SizedBox(height: sp24),
                  InfiniteList<OrderPreviewEntity>(
                    pageSize: state.limit,
                    shrinkWrap: true,
                    getData: (page) => bloc.getListOrder(page + 1),
                    itemBuilder: (context, item, index) {
                      return OrderPreviewCard(item: item);
                    },
                    scrollController: bloc.scrollController,
                    infiniteListController: bloc.infiniteListController,
                    circularProgressIndicator: const BaseLoading(),
                    noItemFoundWidget: const EmptyContainer(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
