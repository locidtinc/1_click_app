import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/data/models/participation_even_model.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/bottom_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/shared_view/widget/row_item.dart';
import 'package:one_click/presentation/view/customer_list/cubit/customer_list_cubit.dart';
import 'package:one_click/presentation/view/participation_even/cubit/participation_event_cubit.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../domain/entity/customer.dart';

@RoutePage()
class ParticipationEventPage extends StatefulWidget {
  const ParticipationEventPage({super.key});

  @override
  State<ParticipationEventPage> createState() => _ParticipationEventPageState();
}

class _ParticipationEventPageState extends State<ParticipationEventPage> {
  final myBloc = getIt.get<ParticipationEventCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParticipationEventCubit>(
      create: (context) => myBloc,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(title: 'Sự kiện'),
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
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: MainButton(
                      //     title: 'Thêm mới khách hàng',
                      //     event: () => context.router.push(const CustomerCreateRoute()).then((value) {
                      //       myBloc.infiniteListController.onRefresh();
                      //     }),
                      //     largeButton: true,
                      //     icon: null,
                      //   ),
                      // ),
                      // const SizedBox(height: sp24),
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
                      InfiniteList<ParticipationEvenModel>(
                        shrinkWrap: true,
                        getData: (page) => myBloc.getListParticipation(page),
                        noItemFoundWidget: const EmptyContainer(),
                        itemBuilder: (context, item, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Center(
                                    child: Text(
                                      '${item.title}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: SizedBox(
                                    width: 250,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        QrImageView(
                                          data: jsonEncode({
                                            'account_id': AppSharedPreference
                                                .instance
                                                .getValue(PrefKeys.user) as int,
                                            'id': item.id,
                                          }),
                                          version: QrVersions.auto,
                                          size: 200,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Account Name: ${AppSharedPreference.instance.getValue(PrefKeys.account)}\nParticipation ID: ${item.id}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Đóng'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: BaseContainer(
                              context,
                              Padding(
                                padding: const EdgeInsets.all(sp8),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/imgs/logo_1click.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(width: sp16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title ?? '',
                                          style: p3.copyWith(color: blackColor),
                                        ),
                                        const SizedBox(height: sp12),
                                        Row(
                                          children: [
                                            // SvgPicture.asset(
                                            //   '${AssetsPath.icon}/ic_phone.svg',
                                            //   color: greyColor,
                                            // ),
                                            // const SizedBox(width: sp8),
                                            Text(
                                              item.subdomain ?? '',
                                              style:
                                                  p4.copyWith(color: greyColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: sp8),
                                        Row(
                                          children: [
                                            Text(
                                              'website',
                                              style:
                                                  p4.copyWith(color: greyColor),
                                            ),
                                            const SizedBox(width: sp8),
                                            Text(
                                              item.website ?? '',
                                              style:
                                                  p4.copyWith(color: greyColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    // GestureDetector(
                                    //   onTap: () => DialogUtils.showErrorDialog(
                                    //     context,
                                    //     content: 'Xác nhận xoá khách hàng này?',
                                    //     titleConfirm: 'Xác nhận',
                                    //     titleClose: 'Đóng lại',
                                    //     close: () => Navigator.pop(context),
                                    //     accept: () {
                                    //   Navigator.pop(context);
                                    //   myBloc.deleteCustomer(
                                    //     context,
                                    //     item.id ?? 0,
                                    //   );
                                    // },
                                    // ),
                                    // child: SvgPicture.asset(
                                    //   '${AssetsPath.icon}/ic_delete.svg',
                                    //   color: greyColor,
                                    //   width: sp16,
                                    // ),
                                    // ),
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
