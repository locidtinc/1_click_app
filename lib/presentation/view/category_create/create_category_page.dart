import 'package:auto_route/annotations.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/category_create/cubit/category_create_cubit.dart';
import 'package:one_click/presentation/view/category_create/cubit/category_create_state.dart';

@RoutePage()
class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final titleTec = TextEditingController();
  final myBloc = getIt.get<CategoryCreateCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCreateCubit>(
      create: (context) => myBloc,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'Tạo ngành hàng'),
        backgroundColor: bg_4,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CategoryCreateCubit, CategoryCreateState>(
                builder: (context, state) {
                  if (titleTec.text != state.title) {
                    titleTec.text = state.title;
                  }
                  return Form(
                    key: context.read<CategoryCreateCubit>().formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: sp24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thông tin ngành hàng',
                                style: p1,
                              ),
                              const SizedBox(height: sp24),
                              AppInput(
                                controller: titleTec,
                                label: 'Tên ngành hàng',
                                hintText: 'Nhập tên ngành hàng',
                                validate: context
                                    .read<CategoryCreateCubit>()
                                    .validateCategory,
                                required: true,
                                onChanged: context
                                    .read<CategoryCreateCubit>()
                                    .onChangeTitle,
                              ),
                              const SizedBox(height: sp16),
                              Container(
                                padding: const EdgeInsets.all(sp16),
                                decoration: BoxDecoration(
                                  color: bg_4,
                                  borderRadius: BorderRadius.circular(sp8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Phân loại',
                                      style: p6.copyWith(color: blackColor),
                                    ),
                                    Text(
                                      'Nội bộ',
                                      style: p5.copyWith(color: blackColor),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            BlocBuilder<CategoryCreateCubit, CategoryCreateState>(
          builder: (context, state) => TwoButtonBox(
            extraTitle: 'Lưu và tạo thêm',
            mainTitle: 'Lưu',
            mainOnTap: () => context
                .read<CategoryCreateCubit>()
                .onTapCreateCategory(context, false),
            extraOnTap: () => context
                .read<CategoryCreateCubit>()
                .onTapCreateCategory(context, true),
          ),
        ),
      ),
    );
  }
}
