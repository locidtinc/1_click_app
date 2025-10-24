import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/group_detail/cubit/group_detail_cubit.dart';
import 'package:one_click/presentation/view/group_detail/cubit/group_detail_state.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/utils/event.dart';

@RoutePage()
class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Chi tiết nhóm sản phẩm',
      ),
      backgroundColor: bg_4,
      body: BlocProvider<GroupDetailCubit>(
        create: (_) => getIt.get<GroupDetailCubit>()..getProductGroupDetail(id),
        child: BlocBuilder<GroupDetailCubit, GroupDetailState>(
          builder: (context, state) {
            final bloc = context.read<GroupDetailCubit>();
            final userId = AppSharedPreference.instance.getValue(PrefKeys.user);
            if (bloc.isLoading) {
              return const BaseLoading();
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: sp24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: sp16,
                            vertical: sp8,
                          ),
                          child: Column(
                            children: [
                              ItemRow(
                                title: 'Tên nhóm sản phẩm',
                                value: state.groups?.title,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                              const SizedBox(height: sp8),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: borderColor_2,
                              ),
                              const SizedBox(height: sp8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ngành hàng',
                                    style: p4.copyWith(color: borderColor_4),
                                  ),
                                  Row(
                                    children: state.groups!.category!
                                        .map(
                                          (e) => Text(
                                            e,
                                            style: p3,
                                          ),
                                        )
                                        .toList(),
                                  )
                                ],
                              ),
                              const SizedBox(height: sp8)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(sp16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Danh sách sản phẩm',
                                style: p1,
                              ),
                              const SizedBox(height: sp16),
                              if (state.groups!.products.isEmpty)
                                Text(
                                  'Chưa có sản phẩm nào',
                                  style: p6.copyWith(color: borderColor_4),
                                ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return CardBase(
                              padding: const EdgeInsets.all(sp16),
                              child: Row(
                                children: [
                                  _imageProduct(state.groups, index),
                                  const SizedBox(width: sp16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.groups?.products[index]
                                                .productName ??
                                            '',
                                        style: p3,
                                      ),
                                      const SizedBox(height: sp8),
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              '${state.groups?.products[index].productCode} - ',
                                          style:
                                              p4.copyWith(color: borderColor_4),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${FormatCurrency(state.groups?.products[index].productPrice)}đ',
                                              style:
                                                  p3.copyWith(color: mainColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: sp16);
                          },
                          itemCount: state.groups!.products.length,
                        ),
                        const SizedBox(height: sp24),
                        if (state.groups?.account == userId)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: sp16),
                            width: double.infinity,
                            child: SupportButton(
                              title: 'Xoá nhóm sản phẩm',
                              event: () => bloc.onTapDeleteCategory(context),
                              icon: null,
                              largeButton: true,
                              backgroundColor: whiteColor,
                              color: mainColor,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<GroupDetailCubit, GroupDetailState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: !(state.groups?.isAdminCreated ?? true),
                      child: Container(
                        padding: const EdgeInsets.all(sp16),
                        color: whiteColor,
                        child: SizedBox(
                          width: double.infinity,
                          child: Extrabutton(
                            title: 'Chỉnh sửa thông tin nhóm sản phẩm',
                            event: () => bloc.onTapEditGroup(context),
                            largeButton: true,
                            borderColor: borderColor_2,
                            icon: null,
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _imageProduct(GroupDetailEntity? group, int index) {
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor_1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            );
          },
          fit: BoxFit.contain,
          imageUrl: group?.products[index].imageUrl ?? '',
          errorWidget: (context, error, value) => Container(
            width: 56,
            height: 56,
            color: borderColor_1,
          ),
        ),
      ),
    );
  }
}
