import 'package:flutter/material.dart';
import 'package:one_click/presentation/base/avatar_base.dart';
import 'package:one_click/presentation/config/bloc/init_state.dart';
import 'package:one_click/presentation/view/store_information/cubit/store_information_cubit.dart';
import 'package:one_click/presentation/view/store_information/cubit/store_information_state.dart';

class StoreAvatar extends StatelessWidget {
  const StoreAvatar({super.key, this.onTapAddAddress, required this.cubit});

  final StoreInformationCubit cubit;
  final VoidCallback? onTapAddAddress;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreInformationCubit, StoreInformationState>(
      builder: (context, state) {
        return BaseAvatar(
          imageUrl: state.storeEntity.avatar ?? '',
          radius: 60,
          isEdit: true,
          onTap: () {
            cubit.onTapAvatar(
              context,
              state.storeEntity.id,
            );
          },
        );
      },
    );
  }
}
