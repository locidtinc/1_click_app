import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/variant_create_order_card.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/promotion/cubit/promotion_cubit.dart';
import 'package:one_click/shared/utils/event.dart';

import '../../../domain/entity/variant_create_order.dart';

@RoutePage()
class OrderCreatePage extends StatefulWidget {
  const OrderCreatePage({
    super.key,
    required this.typeOrder,
    this.idCustomer,
    this.fromBottomBar = false,
    this.isOnline,
  });

  final TypeOrder typeOrder;
  final int? idCustomer;
  final bool fromBottomBar;
  final bool? isOnline;

  @override
  State<OrderCreatePage> createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {
  final bloc = getIt.get<OrderCreateCubit>();
  final promotionBloc = getIt.get<PromotionCubit>()..getTypeRemote();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.fromBottomBar) {
        context.router.push(
          OrderCreateByBarcodeRoute(
            orderCreateCubit: bloc,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCreateCubit>(
      create: (context) => bloc..initData(widget.typeOrder, widget.idCustomer),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: BaseAppBar(
            title:
                'Tạo mới đơn ${widget.typeOrder == TypeOrder.ad ? 'đặt' : 'bán'} hàng',
          ),
          body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp0),
            child: RefreshIndicator(
              onRefresh: () async {
                bloc.infiniteListController.onRefresh();
              },
              child: SingleChildScrollView(
                controller: bloc.scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: sp16),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppInput(
                              hintText: 'Tìm tên, mã sản phẩm',
                              validate: (value) {},
                              backgroundColor: whiteColor,
                              suffixIcon: const Icon(
                                Icons.search,
                                size: sp16,
                              ),
                              onChanged: (value) => bloc.searchKeyChange(value),
                            ),
                          ),
                          // const SizedBox(width: sp16),
                          // Container(
                          //   padding: const EdgeInsets.all(sp16),
                          //   decoration: BoxDecoration(
                          //     color: whiteColor,
                          //     borderRadius: BorderRadius.circular(sp8),
                          //     border: Border.all(color: borderColor_2),
                          //   ),
                          //   child: Center(
                          //     child: SvgPicture.asset(
                          //       '${AssetsPath.icon}/ic_filter.svg',
                          //       width: sp16,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(height: sp24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: sp16),
                      child: SizedBox(
                        width: double.infinity,
                        child: Extrabutton(
                          title: 'Quét mã vạch',
                          event: () => context.router.push(
                            OrderCreateByBarcodeRoute(
                              orderCreateCubit: bloc,
                            ),
                          ),
                          largeButton: true,
                          borderColor: borderColor_2,
                          icon: SvgPicture.asset(
                            '${AssetsPath.icon}/ic_scan_btn.svg',
                          ),
                          bgColor: whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: sp24),
                    BlocBuilder<OrderCreateCubit, OrderCreateState>(
                      builder: (context, state) {
                        // if (state.listCustomer.isEmpty) {
                        //   return const Center(
                        //     child: Text('Bạn chưa có khách hàng nào! Vui lòng tạo mới khách hàng'),
                        //   );
                        // }
                        return InfiniteList<VariantCreateOrderEntity>(
                          shrinkWrap: true,
                          getData: (int page) =>
                              widget.typeOrder == TypeOrder.ad
                                  ? bloc.getList(page)
                                  : bloc.getListVariant(page),
                          itemBuilder: (context, item, index) {
                            return BlocBuilder<OrderCreateCubit,
                                OrderCreateState>(
                              builder: (context, state) {
                                final variant = state.listVariantSelect
                                    .cast<VariantCreateOrderEntity?>()
                                    .firstWhere(
                                      (e) => e!.id == item.id,
                                      orElse: () => null,
                                    );
                                return VariantCreateOrderCard(
                                  // amountTec: TextEditingController(
                                  //   text: (variant ?? item).amount.toString(),
                                  // ),
                                  typeOrder: widget.typeOrder,
                                  variant: variant ?? item,
                                  quantityChange: (
                                    VariantCreateOrderEntity variant,
                                    int value,
                                  ) =>
                                      bloc.changeAmount(variant, value),
                                  toggleCheckbox: (bool? value) =>
                                      bloc.checkboxToggle(variant ?? item),
                                  canDelete: false,
                                );
                              },
                            );
                          },
                          scrollController: bloc.scrollController,
                          infiniteListController: bloc.infiniteListController,
                          circularProgressIndicator: const BaseLoading(),
                          noItemFoundWidget: const EmptyContainer(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: greyColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 40),
                ),
              ],
            ),
            padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
            width: widthDevice(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<OrderCreateCubit, OrderCreateState>(
                        builder: (context, state) {
                          return Text(
                            '${state.listVariantSelect.where(
                                  (e) => e.isChoose,
                                ).toList().length} sản phẩm',
                            style: p4.copyWith(color: greyColor),
                          );
                        },
                      ),
                      const SizedBox(
                        height: sp8,
                      ),
                      BlocBuilder<OrderCreateCubit, OrderCreateState>(
                        builder: (context, state) {
                          return Text(
                            '${FormatCurrency(state.totalPrice)}đ',
                            style: p3.copyWith(color: mainColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MainButton(
                    title: 'Tiếp tục',
                    event: () => context.router.push(
                      OrderCreateConfirmRoute(
                        orderCreateCubit: bloc,
                        isOnline: widget.isOnline,
                      ),
                    ),
                    largeButton: true,
                    icon: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
