import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/row_item.dart';
import 'package:one_click/presentation/view/customer_detail/cubit/customer_detail_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/utils/function.dart';

import '../../base/address_empty.dart';
import '../../shared_view/widget/address_with_map.dart';
import 'cubit/customer_detail_state.dart';

@RoutePage()
class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({super.key, required this.customerEntity});

  final CustomerEntity customerEntity;

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  final myBloc = getIt.get<CustomerDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerDetailCubit>(
      create: (context) => myBloc..initDataCustomer(widget.customerEntity),
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'Chi tiết khách hàng'),
        body: Container(
          width: widthDevice(context),
          height: heightDevice(context),
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
                  builder: (context, state) {
                    return Center(
                      child: BaseContainer(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(sp8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.customerEntity?.fullName ?? '',
                                style: p3,
                              ),
                              const SizedBox(height: sp12),
                              Text(
                                state.customerEntity?.code ??
                                    'Chưa có thông tin',
                                style: p4.copyWith(color: greyColor),
                              ),
                              const SizedBox(height: sp24),
                              SizedBox(
                                width: double.infinity,
                                child: Extrabutton(
                                  title: 'Liên hệ với khách hàng',
                                  event: () => makePhoneCall(
                                    state.customerEntity?.phone ?? '',
                                  ),
                                  largeButton: true,
                                  borderColor: borderColor_2,
                                  icon: SvgPicture.asset(
                                    '${AssetsPath.icon}/ic_phone.svg',
                                    width: sp16,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: sp24),
                              RowItem(
                                title: 'Số điện thoại',
                                content: state.customerEntity?.phone ?? '',
                                titleColor: greyColor,
                              ),
                              const SizedBox(height: sp12),
                              RowItem(
                                title: 'Email',
                                content: state.customerEntity?.email ??
                                    'Chưa có thông tin',
                                titleColor: greyColor,
                              ),
                              const SizedBox(height: sp12),
                              RowItem(
                                title: 'Ngày sinh',
                                content: state.customerEntity?.birthday ??
                                    'Chưa có thông tin',
                                titleColor: greyColor,
                              ),
                              const SizedBox(height: sp12),
                              RowItem(
                                title: 'Địa chỉ',
                                content:
                                    state.customerEntity?.address?.address ??
                                        'Chưa có thông tin',
                                titleColor: greyColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: sp16),
                BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
                  builder: (context, state) {
                    final addressData = state.customerEntity?.address;
                    return state.customerEntity?.address == null
                        ? AddressEmpty(
                            onTapAddAddress: () => null,
                          )
                        : AddressWithMap(
                            canEdit: false,
                            latLng: LatLng(addressData!.lat, addressData.long),
                            address: '${addressData.address}',
                          );
                  },
                ),
                const SizedBox(height: sp16),
                BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
                  builder: (context, state) {
                    return Center(
                      child: BaseContainer(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(sp8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tổng quan đơn hàng', style: p1),
                              const SizedBox(height: sp16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: sp16,
                                  crossAxisSpacing: sp16,
                                  childAspectRatio: 1.5,
                                ),
                                itemBuilder: (context, index) {
                                  final orderCountItem =
                                      state.listOrderCount[index];
                                  return GestureDetector(
                                    onTap: () => context.router.push(
                                      OrderHistoryRoute(
                                        status: orderCountItem.id ?? 1,
                                        customer: state.customerEntity?.id ?? 1,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                        color: borderColor_1,
                                      ),
                                      padding: const EdgeInsets.all(sp16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orderCountItem.count.toString(),
                                            style: h2.copyWith(
                                              color: myBloc.getColor(
                                                orderCountItem.id ?? 0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: sp12),
                                          Text(
                                            orderCountItem.type ?? '',
                                            style: p7,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.listOrderCount.length,
                              ),
                              const SizedBox(height: sp24),
                              SizedBox(
                                width: double.infinity,
                                child: MainButton(
                                  title: 'Tạo đơn bán hàng',
                                  event: () => context.router.push(
                                    OrderCreateRoute(
                                      typeOrder: TypeOrder.cHTH,
                                      idCustomer: state.customerEntity?.id,
                                    ),
                                  ),
                                  largeButton: true,
                                  icon: null,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          color: whiteColor,
          child: SizedBox(
            width: double.infinity,
            child: Extrabutton(
              title: 'Chỉnh sửa thông tin',
              event: () => context.router.push(
                  CustomerEditRoute(customer: myBloc.state.customerEntity)),
              largeButton: true,
              borderColor: borderColor_2,
              icon: null,
            ),
          ),
        ),
      ),
    );
  }
}
