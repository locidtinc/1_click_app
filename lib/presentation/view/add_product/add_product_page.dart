import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/add_product/cubit/add_product_cubit.dart';
import 'package:one_click/presentation/view/add_product/cubit/add_product_state.dart';
import 'package:one_click/shared/button/base_check_box_v2.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../shared/utils/event.dart';

@RoutePage()
class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
    required this.onConfirm,
    required this.listProductInit,
  });

  final Function(List<ProductPreviewEntity> listProductSelected) onConfirm;

  /// list product init dùng để kiểm tra checkbox
  ///
  /// Cải thiện UX cho người dùng
  final List<ProductPreviewEntity> listProductInit;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final myBloc = getIt.get<AddProductCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductCubit>(
      create: (context) =>
          myBloc..updateListProductSelected(widget.listProductInit),
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'Thêm sản phẩm'),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          width: widthDevice(context),
          height: heightDevice(context),
          child: SingleChildScrollView(
            controller: myBloc.scrollController,
            child: Column(
              children: [
                AppInput(
                  hintText: 'Tìm tên, mã sản phẩm',
                  validate: (value) {},
                  backgroundColor: whiteColor,
                  onChanged: (value) => myBloc.searchKeyChange(value),
                  suffixIcon:
                      const Icon(Icons.search, size: sp16, color: greyColor),
                ),
                const SizedBox(
                  height: sp24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Extrabutton(
                    title: 'Quét mã vạch',
                    event: () => context.router.push(
                      ProductBarCodeScanRoute(
                        onScanEvent: (String? barcode) => scanBarcode(barcode),
                      ),
                    ),
                    largeButton: true,
                    icon:
                        SvgPicture.asset('${AssetsPath.icon}/ic_scan_btn.svg'),
                    borderColor: borderColor_2,
                    bgColor: whiteColor,
                  ),
                ),
                const SizedBox(height: sp24),
                BlocBuilder<AddProductCubit, AddProductState>(
                  builder: (context, state) {
                    return InfiniteList<ProductPreviewEntity>(
                      shrinkWrap: true,
                      getData: (page) => myBloc.getListProduct(page),
                      itemBuilder: (context, item, index) {
                        final checked = state.productsSelected
                            .indexWhere((e) => e.id == item.id);
                        return BaseContainer(
                          context,
                          Row(
                            children: [
                              BaseCheckboxV2(
                                fillColor: borderColor_1,
                                checkColor: mainColor,
                                value: checked != -1,
                                onChanged: (value) =>
                                    myBloc.checkboxToggle(item),
                              ),
                              const SizedBox(width: sp16),
                              Expanded(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(sp0),
                                  leading: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: borderColor_2),
                                      borderRadius: BorderRadius.circular(sp8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(sp8),
                                      child: Image.network(
                                        item.imageUrl.isEmpty
                                            ? PrefKeys.imgProductDefault
                                            : item.imageUrl,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    item.productName,
                                    style: p3.copyWith(color: blackColor),
                                  ),
                                  subtitle: Container(
                                    margin: const EdgeInsets.only(top: sp12),
                                    child: RichText(
                                      text: TextSpan(
                                        text: '${item.productCode} -',
                                        style: p4.copyWith(color: greyColor),
                                        children: [
                                          TextSpan(
                                            text:
                                                ' ${FormatCurrency(item.productPrice)}đ',
                                            style:
                                                p4.copyWith(color: mainColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      scrollController: myBloc.scrollController,
                      infiniteListController: myBloc.infiniteListController,
                      circularProgressIndicator: const BaseLoading(),
                      noItemFoundWidget: const EmptyContainer(),
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
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Extrabutton(
                  title: 'Huỷ bỏ',
                  event: () {
                    myBloc.onTapCancel(context);
                  },
                  largeButton: true,
                  borderColor: borderColor_2,
                  icon: null,
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: MainButton(
                  title: 'Xác nhận',
                  event: () {
                    widget.onConfirm.call(myBloc.state.productsSelected);
                    context.router.pop();
                  },
                  largeButton: true,
                  icon: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanBarcode(String? barcode) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tìm kiếm',
    );
    final product = await myBloc.getProductByQrcode(barcode);
    Navigator.of(context).pop();
    if (product != null && context.mounted) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Đã thêm sản phẩm ${product.title}',
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Không tim thấy sản phẩm phù hợp',
      );
    }
  }
}
