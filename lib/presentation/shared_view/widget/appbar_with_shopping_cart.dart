import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/di/di.dart';

import '../../base/app_bar.dart';
import '../../routers/router.gr.dart';
import '../../view/shopping_cart/cubit/shopping_cart_cubit.dart';
import '../../view/shopping_cart/cubit/shopping_cart_state.dart';

class AppBarWithShoppingCart extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithShoppingCart({
    super.key,
    this.title,
    this.mybloc,
  });

  final String? title;
  final ShoppingCartCubit? mybloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
      bloc: mybloc,
      builder: (context, state) {
        return BaseAppBar(
          title: title ?? 'Gian hàng',
          actions: [
            InkWell(
              onTap: () =>
                  context.router.push(ShoppingCartRoute(myBloc: mybloc)),
              child: SizedBox(
                width: sp48,
                child: Center(
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(sp8),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: sp20,
                          color: blackColor,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: sp8,
                          backgroundColor: mainColor,
                          child: Text(
                            '${state.listCart.length}',
                            style: p9.copyWith(color: whiteColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: sp16,
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
