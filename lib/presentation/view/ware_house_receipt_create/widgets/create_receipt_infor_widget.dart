import 'dart:io';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click/gen/assets.gen.dart';
import 'package:one_click/presentation/base/base_container.dart';
import 'package:one_click/presentation/base/dotted_border_button.dart';
import 'package:one_click/presentation/base/input_column.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_cubit.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_state.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/widgets/bts_choose_image.dart';
import 'package:one_click/shared/button/icon_btn.dart';
import 'package:one_click/shared/ext/index.dart';

class CreateReceiptInfor extends StatefulWidget {
  const CreateReceiptInfor({
    super.key,
    required this.bloc,
    required this.inforKey,
  });
  final CreateWarehouseReceiptCubit bloc;
  final GlobalKey<FormState> inforKey;
  @override
  State<CreateReceiptInfor> createState() => _CreateReceiptInforState();
}

class _CreateReceiptInforState extends State<CreateReceiptInfor>
    with AutomaticKeepAliveClientMixin {
  final codeCtrl = TextEditingController();
  final providerCtrl = TextEditingController();
  final inputDateCtrl = TextEditingController(text: DateTime.now().toText());
  final warehouseCtrl = TextEditingController();
  final reasionCtrl = TextEditingController();

  @override
  void dispose() {
    codeCtrl.dispose();
    inputDateCtrl.dispose();
    warehouseCtrl.dispose();
    reasionCtrl.dispose();
    providerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = widget.bloc;
    return BlocListener<CreateWarehouseReceiptCubit,
        CreateWarehouseReceiptState>(
      listener: (context, state) {
        if (state.status == BlocStatus.submitSuccess) {
          codeCtrl.clear();
          inputDateCtrl.clear();
          warehouseCtrl.clear();
          reasionCtrl.clear();
          providerCtrl.clear();
          bloc.addLot();
        }
      },
      child: Form(
        key: widget.inforKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                // visible: false,
                child: InputColumn(
                  controller: codeCtrl,
                  label: 'Mã phiếu',
                  isRequired: true,
                  padding: 0.pading,
                  maxLength: 30,
                  onChanged: (val) {
                    bloc.setCode(val);
                  },
                  validate: (value) {
                    if (value == null || value == '') {
                      return 'Nhập mã phiếu';
                    }
                    return null;
                  },
                ),
              ),
              16.height,
              InputColumn(
                controller: inputDateCtrl,
                readOnly: true,
                label: 'Ngày nhập',
                isRequired: true,
                padding: 0.pading,
                maxLength: 30,
                onTap: () {
                  final date = inputDateCtrl.text.toDate;
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    locale: const Locale('vi'),
                  ).then((value) {
                    if (value != null) {
                      inputDateCtrl.text = value.toText();
                      bloc.setStartDate(inputDateCtrl.text);
                    }
                  });
                },
                suffixIcon: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: Icon(Icons.calendar_month_outlined)),
                ),
                validate: (value) {
                  if (value == null || value == '') {
                    return 'Nhập ngày nhập';
                  }
                  return null;
                },
              ),
              16.height,
              BlocBuilder<CreateWarehouseReceiptCubit,
                  CreateWarehouseReceiptState>(
                bloc: bloc,
                builder: (context, state) {
                  return CommonDropdown(
                    showIconRemove: false,
                    value: bloc.state.warehouse,
                    borderColor: AppColors.input_borderDefault,
                    items: List.generate(
                      bloc.state.listWareHouse.length,
                      (index) => DropdownMenuItem(
                        value: bloc.state.listWareHouse[index],
                        child: Text(
                          bloc.state.listWareHouse[index].title ?? '',
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      bloc.setWareHouse(value);
                    },
                    required: true,
                    label: 'Kho nhập',
                    hintText: 'Chọn kho nhập',
                    color: AppColors.white,
                  );
                },
              ),
              16.height,
              InputColumn(
                label: 'Lý do nhập',
                padding: 0.pading,
                maxLength: 30,
                onChanged: (val) {
                  bloc.setReason(val);
                },
              ),
              16.height,
              InputColumn(
                controller: providerCtrl,
                label: 'Người cung cấp',
                padding: 0.pading,
                maxLength: 30,
                onChanged: (val) {
                  bloc.setProvider(val);
                },
                validate: (value) {},
              ),
              16.height,
              // BlocBuilder<CreateWarehouseReceiptCubit, CreateWarehouseReceiptState>(
              //   bloc: bloc,
              //   builder: (context, state) {
              //     return CommonDropdown(
              //       showIconRemove: false,
              //       value: bloc.state.userCheck,
              //       borderColor: AppColors.input_borderDefault,
              //       items: List.generate(
              //         bloc.listUser.length,
              //         (index) => DropdownMenuItem(
              //           value: bloc.listUser[index],
              //           child: Text(
              //             bloc.listUser[index].fullName ?? '',
              //           ),
              //         ),
              //       ),
              //       onChanged: (value) {
              //         bloc.userCheck = value;
              //       },
              //       required: true,
              //       label: 'Người kiểm tra',
              //       hintText: 'Chọn tài khoản',
              //       color: AppColors.white,
              //     );
              //   },
              // ),
              16.height,
              // Row(
              //   children: [
              //     const Text(
              //       'Tài liệu đi kèm',
              //       style: p5,
              //     ),
              //     const Spacer(),
              //     GestureDetector(
              //       onTap: () => chooseImages(showCamera: false),
              //       child: const BaseContainerV2(
              //         borderColor: AppColors.green20,
              //         width: 32,
              //         height: 32,
              //         borderRadius: 999,
              //         color: AppColors.green60,
              //         child: Center(
              //           child: Icon(Icons.abc),
              //         ),
              //       ),
              //     ),
              //     8.width,
              //     GestureDetector(
              //       onTap: () => chooseImages(showGalary: false),
              //       child: const BaseContainerV2(
              //         borderColor: AppColors.text_tertiary,
              //         width: 32,
              //         height: 32,
              //         borderRadius: 999,
              //         color: AppColors.white,
              //         child: Center(
              //           child: Icon(Icons.abc),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              8.height,
              // Visibility(
              //   visible: false,
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       UploadButton(
              //         preIcon: const Icon(
              //           Icons.abc,
              //           color: AppColors.blue60,
              //         ),
              //         subIcon: const Icon(Icons.abc, color: AppColors.blue60),
              //         title: 'Tải lên tài liệu',
              //         onTap: () {
              //           chooseImages(showCamera: false);
              //         },
              //       ).expanded(),
              //       const SizedBox(width: sp16),
              //       GestureDetector(
              //         onTap: () => chooseImages(showGalary: false),
              //         child: const BaseContainerV2(
              //           borderColor: AppColors.green20,
              //           width: 48,
              //           height: 48,
              //           borderRadius: 999,
              //           color: AppColors.green20,
              //           child: Center(
              //             child: Icon(
              //               Icons.abc,
              //               color: AppColors.brand,
              //               size: 20,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // BlocBuilder<CreateWarehouseReceiptCubit, CreateWarehouseReceiptState>(
              //   bloc: bloc,
              //   builder: (context, state) {
              //     return Column(
              //       children: [
              //         Visibility(
              //           visible: bloc.state.images.isNotEmpty,
              //           child: MainButton(
              //             title: 'Sử dụng AI để lấy sản phẩm',
              //             //  event: () => bloc.getPrdsFromAI(context),
              //             event: (){}
              //           ),
              //         ),
              //         ...List.generate(
              //           bloc.state.images.length,
              //           (index) {
              //             return ItemImage(
              //               index: index,
              //               files: bloc.state.images,
              //               onTap: () {
              //                 bloc.removeFile(index);
              //               },
              //             ).padding(8.padingVer);
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // ),
            ],
          ).padding(16.pading),
        ),
      ),
    );
  }

  // void chooseImages({
  //   bool showCamera = true,
  //   bool showGalary = true,
  // }) {
  //   final images = widget.bloc.images;
  //   final bloc = widget.bloc;
  //   if (bloc.images.length >= 4) {
  //     Toast.show(
  //       context,
  //       title: 'Cảnh báo',
  //       msg: 'Tối đa 4 ảnh đại diện',
  //       color: AppColors.ultility_negative_60,
  //     );
  //     return;
  //   }
  //   BtsChooseImage.show(
  //     context,
  //     limit: 4 - images.length,
  //     showCamera: showCamera,
  //     showGalary: showGalary,
  //   ).then(
  //     (value) {
  //       if (value is List<XFile>) {
  //         for (final element in value) {
  //           if (images.length < 4) {
  //             bloc.addFiles(element);
  //           }
  //         }
  //       }
  //     },
  //   );
  // }

  @override
  bool get wantKeepAlive => true;
}

class ItemImage extends StatelessWidget {
  const ItemImage({
    super.key,
    required this.files,
    required this.index,
    required this.onTap,
  });

  final List<XFile> files;
  final int index;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: 8.radius,
              child: files[index].path.startsWith('http')
                  ? BaseCacheImage(
                      url: files[index].path,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(files[index].path),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
            ),
            12.width,
            Row(
              children: [
                Text(
                  'Ảnh dịch vụ ${index + 1}',
                  style: AppStyle.bodyBsMedium.copyWith(
                    height: 1.5,
                  ),
                ).expanded(),
                12.width,
                IconBtn(
                  onTap: () => onTap?.call(),
                  size: const Size(24, 24),
                  padding: 4.pading,
                  icon: const Icon(
                    Icons.remove,
                    size: sp24,
                    color: AppColors.button_neutral_alpha_iconDefault,
                  ),
                ),
              ],
            ).expanded(),
          ],
        ).container(
          padding: 12.pading,
          radius: 12,
          border: Border.all(color: AppColors.border_tertiary),
        ),
        Positioned(
          bottom: 5,
          right: 10,
          child: Text(
            '${index + 1}/4',
            textAlign: TextAlign.right,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_quaternary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
