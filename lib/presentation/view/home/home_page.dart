import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/avatar_base.dart';
import 'package:one_click/presentation/base/bottom_bar.dart';
import 'package:one_click/presentation/base/date_time_widget.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/home/cubit/home_cubit.dart';
import 'package:one_click/presentation/view/home/cubit/home_state.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/param_date.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../../shared/services/notification/notification.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myBloc = getIt.get<HomeCubit>();

  final account = AppSharedPreference.instance.getValue(PrefKeys.username);

  Future<void> initFirebase() async {
    await NotiService.intinializeNotiService(context);
    FirebaseMessaging.onBackgroundMessage(
      NotiService.firebaseMessagingBackroundHandler,
    );
    await NotiService.getDeviceToken();

    final idUser = AppSharedPreference.instance.getValue(PrefKeys.user);
    await FirebaseMessaging.instance.subscribeToTopic('ACCOUNT_$idUser');
  }

  Future<void> onSelectNoti(RemoteMessage data) async {
    context.router.push(
      OrderDetailRoute(
        order: int.parse(data.data['order_id']),
        typeOrder: data.data['type_order'] == 'ORDERSYSTEM'
            ? TypeOrder.ad
            : TypeOrder.cHTH,
      ),
    );
  }

  @override
  void initState() {
    myBloc.getDailyOrder();
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => myBloc..getStoreInfo(),
      child: Scaffold(
        backgroundColor: bg_4,
        body: RefreshIndicator(
          onRefresh: myBloc.getDailyOrder,
          child: SizedBox(
            height: heightDevice(context),
            width: widthDevice(context),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return state.isLoading
                    ? const BaseLoading()
                    : Stack(
                        children: [
                          Image.asset(
                            '${AssetsPath.image}/img_home_header.png',
                            width: widthDevice(context),
                            fit: BoxFit.cover,
                          ),
                          ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(
                                height: 64,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => context.router.push(
                                        StoreInformationRoute(myBloc: myBloc)),
                                    child: Container(
                                      height: 46,
                                      width: 46,
                                      decoration: const BoxDecoration(
                                        color: whiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        // child: SvgPicture.asset(
                                        //   '${AssetsPath.icon}/ic_shop.svg',
                                        // ),
                                        child: BaseAvatar(
                                          imageUrl:
                                              state.storeEntity.avatar ?? '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: sp16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Xin chào,',
                                          style: p6.copyWith(color: whiteColor),
                                        ),
                                        const SizedBox(height: sp8),
                                        Text(
                                          state.storeEntity.nameStore,
                                          style: p5.copyWith(color: whiteColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        context.router.push(const NotiRoute()),
                                    child: Container(
                                      height: 46,
                                      width: 46,
                                      decoration: const BoxDecoration(
                                        color: whiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          '${AssetsPath.icon}/ic_notification_fill.svg',
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: sp16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: blackColor.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: const Offset(
                                        0,
                                        5,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Thống kê nhanh',
                                          style: p7,
                                        ),
                                        Visibility(
                                          visible: false,
                                          child: Text(
                                            'Xem tất cả',
                                            style: p7.copyWith(color: blue_1),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              // final dates = await showCalendarDatePicker2Dialog(
                                              //   context: context,
                                              //   config: CalendarDatePicker2WithActionButtonsConfig(
                                              //     calendarType: CalendarDatePicker2Type.range,
                                              //     calendarViewMode: CalendarDatePicker2Mode.day,
                                              //     selectedDayHighlightColor: mainColor,
                                              //   ),
                                              //   dialogSize: Size(widthDevice(context) - sp32, 450),
                                              // );
                                              // myBloc.selectDatesSearch(
                                              //   [
                                              //     dates?.first,
                                              //     dates?.last,
                                              //   ],
                                              // );
                                              context
                                                  .dialog(DateTimeWidget())
                                                  .then((value) {
                                                if (value is ParamDate) {
                                                  print(
                                                      'value ${value.toJson()}');
                                                  print(
                                                      'value ${value.startDate}');
                                                  print(
                                                      'value ${value.endDate}');

                                                  myBloc.selectDatesSearch(
                                                    value,
                                                    [
                                                      value.startDate,
                                                      value.endDate,
                                                    ],
                                                  );
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    state.dates.isEmpty
                                                        ? 'Lọc thời gian'
                                                        : state.paramDate
                                                                        ?.dateRange ==
                                                                    DateRangeEnum
                                                                        .option &&
                                                                state.paramDate !=
                                                                    null
                                                            ? '${state.paramDate?.startDate?.toText(fomat: 'dd/MM/yyyy')}'
                                                                ' - ${state.paramDate?.endDate?.toText(fomat: 'dd/MM/yyyy')}'
                                                            : state
                                                                    .paramDate
                                                                    ?.dateRange
                                                                    ?.toName ??
                                                                'Hôm nay',
                                                    // state.dates.isEmpty
                                                    //     ? 'Lọc thời gian'
                                                    //     : '${state.dates.first?.toText(fomat: 'dd/MM/yyyy')}'
                                                    //         ' - ${state.dates.last?.toText(fomat: 'dd/MM/yyyy')}',
                                                    style: p6.copyWith(
                                                      color: mainColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.calendar_month,
                                                  size: sp20,
                                                  color: mainColor,
                                                ),
                                                // InkWell(
                                                //   onTap: myBloc.resetDate,
                                                //   child: const Icon(
                                                //     Icons.clear,
                                                //     size: sp20,
                                                //     color: blackColor,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: sp16),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Doanh thu',
                                                        style: p7.copyWith(
                                                          color: greyColor,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: sp12,
                                                      ),
                                                      Text(
                                                        '${FormatCurrency(state.dailyOderEntity.totatRevenue)} đ',
                                                        style: p3.copyWith(
                                                          color: blackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: borderColor_1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: sp16,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Đơn hàng',
                                                        style: p7.copyWith(
                                                          color: greyColor,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: sp8),
                                                      Text(
                                                        '${state.dailyOderEntity.totalNumberOfOrders.toInt()}',
                                                        style: p3.copyWith(
                                                          color: blackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: sp24),
                              Text(
                                'Danh mục chức năng',
                                style: p1.copyWith(color: blackColor),
                              ),
                              BlocBuilder<HomeCubit, HomeState>(
                                builder: (context, state) {
                                  return GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: sp16,
                                      crossAxisSpacing: sp16,
                                      childAspectRatio: 2,
                                    ),
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () => context.router.push(
                                        myBloc.listFunc[index].page ??
                                            const HomeRoute(),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(sp16),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(sp8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: greyColor.withOpacity(0.1),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: const Offset(
                                                0,
                                                5,
                                              ), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (myBloc.listFunc[index].icon
                                                .endsWith('.svg'))
                                              SvgPicture.asset(
                                                '${AssetsPath.icon}${myBloc.listFunc[index].icon}',
                                                width: 30,
                                                height: 30,
                                              ),
                                            if (myBloc.listFunc[index].icon
                                                .endsWith('.png'))
                                              Image.asset(
                                                '${AssetsPath.image}${myBloc.listFunc[index].icon}',
                                                width: 30,
                                                height: 30,
                                              ),
                                            const SizedBox(height: sp8),
                                            Text(
                                              myBloc.listFunc[index].title,
                                              style: p7.copyWith(
                                                  color: blackColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    itemCount: myBloc.listFunc.length,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
        bottomNavigationBar: const BuildBottomBar(
          pageCode: TabCode.home,
        ),
      ),
    );
  }
}
