import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/data/models/store_model/bank_data.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/add_bank/widgets/cubit/search_bank_cubit.dart';
import 'package:one_click/presentation/view/add_bank/widgets/cubit/search_bank_state.dart';

class SelectBankWidget extends StatelessWidget {
  const SelectBankWidget({
    super.key,
    required this.listBank,
    required this.onTapItem,
    this.isSelected = false,
    required this.title,
    this.isBank = false,
  });

  final List<BankData> listBank;
  final bool isSelected;
  final Function(BankData) onTapItem;
  final String title;
  final bool isBank;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBankCubit>(
      create: (_) => getIt.get<SearchBankCubit>()..initData(listBank),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(sp16),
                  child: Center(
                    child: Text(
                      title,
                      style: p3,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: borderColor_2,
                ),
                BlocBuilder<SearchBankCubit, SearchBankState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(sp16),
                      child: AppInput(
                        hintText: 'Tìm kiếm',
                        validate: (value) {},
                        backgroundColor: whiteColor,
                        prefixIcon: const Icon(
                          Icons.search,
                          size: sp16,
                        ),
                        onChanged: context.read<SearchBankCubit>().onChanged,
                      ),
                    );
                  },
                ),
                Expanded(child: _buildList()),
              ],
            ),
            Positioned(
              top: 16,
              left: 16,
              child: InkWell(
                onTap: Navigator.of(context).pop,
                child: Text(
                  'Đóng',
                  style: p5.copyWith(color: blue_1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<SearchBankCubit, SearchBankState>(
      buildWhen: (pre, cur) =>
          pre.listBankSearch.length != cur.listBankSearch.length,
      builder: (context, state) {
        return state.isEmpty
            ? const Center(child: Text('No data', style: p3))
            : ListView.separated(
                shrinkWrap: true,
                itemCount: state.listBankSearch.length,
                padding: const EdgeInsets.only(top: sp8, bottom: sp24),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onTapItem(state.listBankSearch[index]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: sp16,
                        vertical: sp12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: borderColor_2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: CachedNetworkImage(
                                    width: 44,
                                    height: 44,
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      );
                                    },
                                    imageUrl:
                                        state.listBankSearch[index].image ?? '',
                                  ),
                                ),
                                const SizedBox(width: sp8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.listBankSearch[index].shortName ??
                                            '',
                                        style: p4.copyWith(
                                          color: blackColor,
                                        ),
                                      ),
                                      const SizedBox(height: sp4),
                                      Text(
                                        state.listBankSearch[index].title,
                                        style: p7.copyWith(
                                          color: borderColor_4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: green_1,
                            )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: sp16),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: borderColor_2,
                    ),
                  );
                },
              );
      },
    );
  }
}
