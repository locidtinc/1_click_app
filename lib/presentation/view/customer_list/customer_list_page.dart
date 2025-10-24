import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/bottom_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/customer_list/cubit/customer_list_cubit.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../domain/entity/customer.dart';

@RoutePage()
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final myBloc = getIt.get<CustomerListCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerListCubit>(
      create: (context) => myBloc,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(title: 'Quản lý khách hàng'),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: sp24,
              horizontal: sp16,
            ),
            child: Container(
              height: heightDevice(context),
              width: widthDevice(context),
              child: RefreshIndicator(
                onRefresh: () async {
                  myBloc.infiniteListController.onRefresh();
                },
                child: SingleChildScrollView(
                  controller: myBloc.scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          title: 'Thêm mới khách hàng',
                          event: () => context.router
                              .push(const CustomerCreateRoute())
                              .then((value) {
                            myBloc.infiniteListController.onRefresh();
                          }),
                          largeButton: true,
                          icon: null,
                        ),
                      ),
                      const SizedBox(height: sp24),
                      AppInput(
                        hintText: 'Tìm kiếm',
                        validate: (value) {},
                        suffixIcon: const Icon(
                          Icons.search,
                          size: sp16,
                          color: greyColor,
                        ),
                        onChanged: (value) => myBloc.searchKeyChange(value),
                        backgroundColor: whiteColor,
                      ),
                      const SizedBox(height: sp16),
                      InfiniteList<CustomerEntity>(
                        shrinkWrap: true,
                        getData: (page) => myBloc.getCustomer(page),
                        noItemFoundWidget: const EmptyContainer(),
                        itemBuilder: (context, item, index) {
                          return GestureDetector(
                            onTap: () => context.router.push(
                                CustomerDetailRoute(customerEntity: item)),
                            child: BaseContainer(
                              context,
                              Padding(
                                padding: const EdgeInsets.all(sp8),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        (item.image?.isEmpty ?? true)
                                            ? PrefKeys.avatarDefault
                                            : item.image!,
                                      ),
                                    ),
                                    const SizedBox(width: sp16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.fullName ?? '',
                                          style: p3.copyWith(color: blackColor),
                                        ),
                                        const SizedBox(height: sp12),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              '${AssetsPath.icon}/ic_phone.svg',
                                              color: greyColor,
                                            ),
                                            const SizedBox(width: sp8),
                                            Text(
                                              item.phone ?? '',
                                              style:
                                                  p4.copyWith(color: greyColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => DialogUtils.showErrorDialog(
                                        context,
                                        content: 'Xác nhận xoá khách hàng này?',
                                        titleConfirm: 'Xác nhận',
                                        titleClose: 'Đóng lại',
                                        close: () => Navigator.pop(context),
                                        accept: () {
                                          Navigator.pop(context);
                                          myBloc.deleteCustomer(
                                            context,
                                            item.id ?? 0,
                                          );
                                        },
                                      ),
                                      child: SvgPicture.asset(
                                        '${AssetsPath.icon}/ic_delete.svg',
                                        color: greyColor,
                                        width: sp16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        scrollController: myBloc.scrollController,
                        infiniteListController: myBloc.infiniteListController,
                        circularProgressIndicator: const BaseLoading(),
                      ),
                    ],
                  ),
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
