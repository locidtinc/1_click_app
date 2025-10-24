import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/shared/utils/dismiss_keyboard.dart';

import '../../base/app_bar.dart';
import '../../base/bottom_bar.dart';
import '../../di/di.dart';
import 'cubit/order_manager_cubit.dart';
import 'cubit/order_manager_state.dart';

@RoutePage()
class OrderManagerPage extends StatelessWidget {
  const OrderManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderManagerCubit>(
      create: (context) => getIt.get<OrderManagerCubit>(),
      child: BlocBuilder<OrderManagerCubit, OrderManagerState>(
        builder: (context, state) {
          return DefaultTabController(
            initialIndex: 0,
            length: state.listTab.length,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => AppUtils.dissmissKeyboard(),
              child: Scaffold(
                appBar: BaseAppBar(
                  height: kToolbarHeight * 1.8,
                  title: 'Danh sách đơn bán hàng',
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: mainColor,
                    labelColor: blackColor,
                    unselectedLabelColor: greyColor,
                    tabs: state.listTab
                        .map(
                          (e) => Tab(
                            text: e.title,
                          ),
                        )
                        .toList(),
                  ),
                ),
                body: TabBarView(
                  children: state.listTab.map((e) => e.page).toList(),
                ),
                bottomNavigationBar: const BuildBottomBar(
                  pageCode: TabCode.another,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
