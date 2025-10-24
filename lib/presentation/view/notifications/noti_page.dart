import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/notifications/cubit/noti_cubit.dart';
import 'package:one_click/presentation/view/notifications/cubit/noti_state.dart';
import 'package:one_click/presentation/view/notifications/widgets/noti_card.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';

@RoutePage()
class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  final myBloc = getIt.get<NotiCubit>();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotiCubit>(
      create: (context) => myBloc..getListNew(1),
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'Thông báo'),
        body: Container(
          height: heightDevice(context),
          width: widthDevice(context),
          padding: const EdgeInsets.symmetric(vertical: sp24),
          child: RefreshIndicator(
            onRefresh: () async {
              myBloc.getListNew(1);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<NotiCubit, NotiState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: sp16),
                      child: Row(
                        children: state.listFilter
                            .map(
                              (e) => GestureDetector(
                                onTap: () => myBloc.filterOnChange(e),
                                child: Container(
                                  margin: const EdgeInsets.only(right: sp8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    color: e == state.filterSelect
                                        ? accentColor_1
                                        : whiteColor,
                                  ),
                                  padding: const EdgeInsets.all(sp12),
                                  child: Text(
                                    '${e.title} (${e == TypeNoti.all ? (state.listNoti?.notifications?.length ?? 0) : (state.listNoti?.unreadCount ?? 0)})',
                                    style: p5.copyWith(
                                      color: e == state.filterSelect
                                          ? whiteColor
                                          : greyColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
                // FilterButton(listFilter, selectFilter, (value) => null),
                // const SizedBox(height: sp24),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: sp16),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: Extrabutton(
                //       title: 'Đánh dấu đã đọc tất cả',
                //       event: () => myBloc.updateAllNoti(),
                //       largeButton: true,
                //       borderColor: borderColor_2,
                //       icon: null,
                //       bgColor: whiteColor,
                //     ),
                //   ),
                // ),
                const SizedBox(height: sp24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: sp16),
                  child: Text('Mới nhất', style: p7),
                ),
                const SizedBox(height: sp16),
                Expanded(
                  child: BlocBuilder<NotiCubit, NotiState>(
                    builder: (context, state) {
                      final isAll = state.filterSelect == TypeNoti.all;
                      final listNotis = state.listNoti?.notifications
                          ?.where((e) => isAll ? true : !(e.isReaded ?? false))
                          .toList();
                      return listNotis != null && listNotis.isNotEmpty
                          ? ListView.builder(
                              controller: scrollController,
                              itemCount: listNotis.length,
                              itemBuilder: (context, index) {
                                if (index < listNotis.length) {
                                  final noti = listNotis[index];
                                  return GestureDetector(
                                    onTap: () {
                                      myBloc.updateNoti(noti);
                                      context.router.push(
                                        OrderDetailRoute(
                                          order: noti.orderId ?? 0,
                                          isNotiOder: true,
                                          typeOrder: TypeOrder.ad,
                                        ),
                                      );
                                    },
                                    child: NotiCard(
                                      notiEntity: noti,
                                    ),
                                  );
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            )
                          : SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'Danh sách trống',
                                  textAlign: TextAlign.center,
                                  style: p6.copyWith(
                                    color: borderColor_4,
                                  ),
                                ),
                              ),
                            );
                    },
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
