import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/bottom_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/product_manager/cubit/product_manager_cubit.dart';
import 'package:one_click/presentation/view/product_manager/cubit/product_manager_state.dart';
import 'package:one_click/shared/utils/dismiss_keyboard.dart';

@RoutePage()
class ProductManagerPage extends StatelessWidget {
  ProductManagerPage({super.key});

  final myBloc = getIt.get<ProductManagerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductManagerCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<ProductManagerCubit, ProductManagerState>(
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => AppUtils.dissmissKeyboard(),
            child: DefaultTabController(
              initialIndex: 0,
              length: myBloc.listTab.length,
              child: Scaffold(
                appBar: BaseAppBar(
                  height: kToolbarHeight * 1.8,
                  title: 'Quản lý sản phẩm',
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.notifications_outlined,
                  //       color: blackColor,
                  //       size: sp16,
                  //     ),
                  //   ),
                  // ],
                  bottom: TabBar(
                    // isScrollable: true,
                    indicatorColor: mainColor,
                    tabs: myBloc.listTab
                        .map(
                          (e) => Tab(
                            child: Text(
                              e.title,
                              style: p5.copyWith(
                                color: blackColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                body: TabBarView(
                  children: myBloc.listTab.map((e) => e.page).toList(),
                ),
                // bottomNavigationBar: const BuildBottomBar(
                //   pageCode: TabCode.another,
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}
