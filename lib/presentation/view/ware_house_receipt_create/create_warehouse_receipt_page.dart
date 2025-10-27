import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/base_buttom_bar.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/config/bloc/index_bloc.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_cubit.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_state.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/widgets/create_receipt_infor_widget.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/widgets/create_receipt_shipment_widget.dart';
import 'package:one_click/shared/ext/index.dart';

@RoutePage()
class CreateWarehouseReceiptPage extends StatefulWidget {
  const CreateWarehouseReceiptPage({
    super.key,
  });
  // final ProductV3Model? product;

  @override
  State<CreateWarehouseReceiptPage> createState() =>
      _CreateWarehouseReceiptPageState();
}

class _CreateWarehouseReceiptPageState extends State<CreateWarehouseReceiptPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final createWarehouseReceiptCubit = getIt<CreateWarehouseReceiptCubit>();
  final indexCubit = IndexBloc();
  final inforKey = GlobalKey<FormState>();
  final shipmentKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    createWarehouseReceiptCubit.getListWareHouse();
    // ..getListUserWareHouse();
    // ..addLot(productData: widget.product);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => createWarehouseReceiptCubit),
        BlocProvider(create: (context) => indexCubit),
      ],
      child: BlocListener<CreateWarehouseReceiptCubit,
          CreateWarehouseReceiptState>(
        listener: (context, state) {
          if (state.status == BlocStatus.submitSuccess) {
            DialogUtils.showSuccessDialog(
              context,
              content: 'Bạn đã tạo đơn thành công',
              close: () => context.pop(),
              accept: () {
                context.pop();
                context.pop();
              },
            );
          } else if (state.status == BlocStatus.submitFailure) {
            DialogUtils.showErrorDialog(
              context,
              content: 'Tạo đơn thất bại \n${state.msg}',
              close: () => context.pop(),
              accept: () => context.pop(),
            );
          }
        },
        child: Scaffold(
          appBar: AppBarCustom(
            onBack: () {
              context.router.pop(createWarehouseReceiptCubit.state.hasUpdate);
            },
            height: 90,
            title: 'Quản lý phiếu nhập kho',
            subTitle: 'Tạo mới phiếu nhập kho',
          ),
          body: Column(
            children: [
              TabBar(
                onTap: (value) {
                  indexCubit.change(value);
                },
                padding: EdgeInsets.zero,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Thông tin cơ bản'),
                  Tab(text: 'Lô hàng'),
                ],
                unselectedLabelColor: AppColors.grey60,
                indicatorColor: AppColors.brand,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: p7.copyWith(color: AppColors.brand),
              ),
              BlocBuilder<IndexBloc, int>(
                builder: (context, state) {
                  return IndexedStack(
                    index: state,
                    children: [
                      CreateReceiptInfor(
                        bloc: createWarehouseReceiptCubit,
                        inforKey: inforKey,
                      ),
                      CreateReceiptShipmentWidget(
                        bloc: createWarehouseReceiptCubit,
                        shipmentKey: shipmentKey,
                      ),
                    ],
                  );
                },
              ).expanded(),
              // TabBarView(
              //   controller: _tabController,
              //   children: [
              //     CreateReceiptInfor(
              //       bloc: createWarehouseReceiptCubit,
              //       inforKey: inforKey,
              //     ),
              //     CreateReceiptShipmentWidget(
              //       bloc: createWarehouseReceiptCubit,
              //       shipmentKey: shipmentKey,
              //     ),
              //   ],
              // ).expanded(),
            ],
          ),
          bottomNavigationBar: BaseBottomBar(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Extrabutton(
                    title: 'Hủy bỏ',
                    event: () => context.router.pop(),
                    borderColor: borderColor_2,
                    largeButton: true,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                BlocBuilder<IndexBloc, int>(
                  builder: (context, state) {
                    return Expanded(
                      child: MainButton(
                        title: 'Xác nhận',
                        event: () {
                          final isInforValid =
                              inforKey.currentState!.validate();
                          final isShipmentValid =
                              shipmentKey.currentState!.validate();
                          if (!isInforValid || !isShipmentValid) {
                            DialogUtils.showErrorDialog(
                              context,
                              close: () => context.pop(),
                              accept: () => context.pop(),
                              content: 'Bạn chưa nhập đủ thông tin',
                            );
                            if (state == 0 && !isInforValid) {
                              return;
                            } else if (state == 1 && !isShipmentValid) {
                              return;
                            }
                            final index = !isInforValid ? 0 : 1;
                            _tabController.animateTo(
                              index,
                              duration: 300.milliseconds,
                            );
                            indexCubit.change(index);
                            return;
                          }
                          createWarehouseReceiptCubit.createReceipt(context);
                        },
                        largeButton: true,
                        icon: null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({
    super.key,
    required this.title,
    required this.subTitle,
    required this.height,
    this.onTap,
    this.actions,
    this.onBack,
  });
  final String title;
  final String subTitle;
  final double height;
  final void Function()? onTap;
  final void Function()? onBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(onTap: onBack, child: const Icon(Icons.arrow_back_ios)),
      elevation: 1,
      backgroundColor: AppColors.white,
      iconTheme: const IconThemeData(
        color: AppColors.text_tertiary,
      ),
      centerTitle: false,
      title: Text(
        title,
        style: p5.copyWith(color: AppColors.text_tertiary),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 32),
        child: Row(
          children: [
            Text(
              subTitle,
              style: h3,
            ),
            const Spacer(),
            if (actions != null) ...actions!,
            // else
            // GestureDetector(
            //   onTap: onTap,
            //   child:  const Icon(Icons.more_vert_outlined,size: 28,),
            // ),
          ],
        ).padding(58.padingLeft + 32.padingRight + 8.padingVer),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
