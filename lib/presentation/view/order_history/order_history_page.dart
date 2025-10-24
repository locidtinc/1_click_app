import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/shared_view/widget/row_item.dart';
import 'package:one_click/presentation/view/order_history/cubit/order_history_cubit.dart';
import 'package:one_click/shared/utils/event.dart';

@RoutePage()
class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({
    super.key,
    required this.status,
    required this.customer,
  });

  final int status;
  final int customer;

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final myBloc = getIt.get<OrderHistoryCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      appBar: const BaseAppBar(title: 'Lịch sử đơn hàng'),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
        width: widthDevice(context),
        height: heightDevice(context),
        child: SingleChildScrollView(
          controller: myBloc.scrollController,
          physics: const BouncingScrollPhysics(),
          child: InfiniteList<OrderPreviewEntity>(
            shrinkWrap: true,
            pageSize: myBloc.state.limit,
            getData: (page) => myBloc.getList(
              page: page,
              status: widget.status,
              customer: widget.customer,
            ),
            itemBuilder: (context, item, index) {
              return BaseContainer(
                context,
                Padding(
                  padding: const EdgeInsets.all(sp8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.code,
                            style: p3.copyWith(color: blackColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: sp12,
                              horizontal: sp16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp8),
                              color: getBackgroundColorByStatus(item.status.id),
                            ),
                            child: Text(
                              item.status.title,
                              style: p5.copyWith(
                                color: getColorByStatus(item.status.id),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: sp16),
                      const Divider(height: 1),
                      const SizedBox(height: sp16),
                      const RowItem(
                        title: 'Số lượng sản phẩm',
                        content: 'item.total',
                      ),
                      const SizedBox(height: sp12),
                      RowItem(
                        title: 'Số lượng sản phẩm',
                        content: '${FormatCurrency(item.total)}đ',
                      )
                    ],
                  ),
                ),
              );
            },
            scrollController: myBloc.scrollController,
            infiniteListController: myBloc.infiniteListController,
            circularProgressIndicator: const BaseLoading(),
            noItemFoundWidget: const EmptyContainer(),
          ),
        ),
      ),
    );
  }
}
