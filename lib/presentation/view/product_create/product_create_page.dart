import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/data/models/payload/product/payload_variant.dart';
import 'package:one_click/data/models/payload/product/product_properties.dart';
import 'package:one_click/data/models/payload/product/unit_v2_model.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/empty_view.dart';
import 'package:one_click/presentation/base/label_button.dart';
import 'package:one_click/presentation/base/switch.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';
import 'package:one_click/presentation/view/product_create/widgets/base_price_item.dart';
import 'package:one_click/presentation/view/product_create/widgets/bts_config_base_price.dart';
import 'package:one_click/presentation/view/product_create/widgets/bts_config_unit_sell.dart';
import 'package:one_click/presentation/view/product_create/widgets/item_create_unit.dart';
import 'package:one_click/presentation/view/product_create/widgets/product_field_widget.dart';
import 'package:one_click/presentation/view/product_create/widgets/product_image_widget.dart';
import 'package:one_click/presentation/view/product_create/widgets/product_more_info.dart';
import 'package:one_click/presentation/view/product_create/widgets/propertie_field_widget.dart';
import 'package:one_click/presentation/view/product_create/widgets/variant_default_widget.dart';
import 'package:one_click/presentation/view/product_create/widgets/variant_field_widget.dart';
import 'package:one_click/shared/constants/format/number.dart';
import 'package:one_click/shared/ext/index.dart';

@RoutePage()
class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({
    super.key,
    required this.callPreviousPage,
    this.productDetailEntity,
  });

  final Function()? callPreviousPage;
  final ProductDetailEntity? productDetailEntity;
  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  List<ProductPropertiesModel> _listProductProperties =
      <ProductPropertiesModel>[];

  List<PayloadVariantModel> _listVariantModel = <PayloadVariantModel>[];

  late ExpandableController expandableController;
  late ExpandableController expandableControllerMoreInfo;
  late ExpandableController expandableControllerProductInfo;

  final TextEditingController priceSell = TextEditingController();
  final TextEditingController priceImport = TextEditingController();

  final TextEditingController nameVariantController = TextEditingController();

  List<DropdownMenuItem> listBrandDropdonw = [];
  List<DropdownMenuItem> listCategoryDropdonw = [];
  List<DropdownMenuItem> listGroupDropdonw = [];

  Future<void> getDataProductGroup() async {
    listGroupDropdonw = await myBloc.getListProductGroup();
  }

  final _scrollController = ScrollController();
  final myBloc = getIt.get<ProductCreateCubit>();
  final _listBrandCtrl = TextEditingController();
  final _listCategoryCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Future.wait([
    //     getDataProductBrand(),
    //     getDataProductCategory(),
    //   ]);
    //   setState(() {});
    // });
    myBloc.getListProductBrand();
    myBloc.getListProductCategory();
    expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    expandableControllerMoreInfo = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    expandableControllerProductInfo =
        ExpandableController(initialExpanded: true)
          ..addListener(() {
            setState(() {});
          });
  }

  void _addProperties() {
    setState(() {
      if (_listProductProperties.length < 3) {
        _listProductProperties.add(
          ProductPropertiesModel(
            name: TextEditingController(),
            value: <String>[],
            controller: ExpandableController(initialExpanded: true)
              ..addListener(() {
                setState(() {});
              }),
            isUse: true,
            id: Random().nextInt(1000000000),
          ),
        );
      }
    });
  }

  void _selectProductScan(ProductDetailEntity product) {
    setState(() {
      priceSell.text = formatPrice(product.priceSell.round()).toString();
      priceImport.text = formatPrice(product.priceImport.round()).toString();
      nameVariantController.text = product.title;
      _listProductProperties = product.properties
          .map(
            (e) => ProductPropertiesModel(
              name: TextEditingController(text: e.title),
              value: Set<String>.from(e.childProperties).toList(),
              controller: ExpandableController(initialExpanded: true)
                ..addListener(() {
                  setState(() {});
                }),
              isUse: true,
              id: Random().nextInt(1000000000),
            ),
          )
          .toList();
    });
    _setFormula();
  }

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCreateCubit>(
      create: (context) => myBloc,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: bg_4,
          appBar: const BaseAppBar(
            title: 'Tạo sản phẩm',
          ),
          bottomNavigationBar: _bottomBar(),
          body: SingleChildScrollView(
            controller: _scrollController,

            // padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            padding: 24.padingTop + 16.padingHor,

            physics: const BouncingScrollPhysics(),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Product
                  const ProductImagePickerView(),
                  const SizedBox(height: sp16),
                  // Info Product
                  ProductFieldView(
                    expandableController: expandableControllerProductInfo,
                    priceImportTec: priceImport,
                    priceSellTec: priceSell,
                    productCreateCubit: myBloc,
                    onSelectProductScan: (product) =>
                        _selectProductScan.call(product),
                    productDetailEntity: widget.productDetailEntity,
                  ),
                  const SizedBox(height: sp24),
                  // Propertie Product
                  // const Text(
                  //   'Thuộc tính',
                  //   style: p1,
                  // ),
                  const Text(
                    'Chi tiết mẫu mã sản phẩm',
                    style: p1,
                  ),
                  const SizedBox(
                    height: sp16,
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: sp16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final propertie = _listProductProperties[index];
                      return PropertieFieldView(
                        propertie: propertie,
                        addPropertieValue: (value) => setState(() {
                          propertie.value!.add(value);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            propertie.focusNode?.requestFocus();
                          });
                          _setFormula();
                        }),
                        deletePropertieValue: (value) => setState(() {
                          propertie.value!.remove(value);
                          _setFormula();
                        }),
                        deletePropertie: () => setState(() {
                          _listProductProperties.remove(propertie);
                          _setFormula();
                        }),
                      );
                    },
                    itemCount: _listProductProperties.length,
                  ),
                  if (_listProductProperties.isNotEmpty)
                    const SizedBox(
                      height: sp16,
                    ),
                  GestureDetector(
                    onTap: () => _addProperties(),
                    child: DottedBorder(
                      color: blue_1,
                      borderType: BorderType.RRect,
                      padding: const EdgeInsets.symmetric(vertical: sp12),
                      radius: const Radius.circular(8),
                      dashPattern: const [3, 6],
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(sp8)),
                        child: Center(
                          child: Text(
                            'Thêm thuộc tính ( ${_listProductProperties.length}/3 )',
                            style: p5.copyWith(color: blue_1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: sp24),
                  // Variant List
                  Text(
                    'Mẫu mã (${_listVariantModel.length})',
                    style: p1,
                  ),
                  const SizedBox(height: sp16),
                  //VariantView
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variant = _listVariantModel[index];
                      print('======variant$variant');
                      // final prdProperties = _listProductProperties[index];
                      return VariantFieldView(
                        variant: variant,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: sp16),
                    itemCount: _listVariantModel.length,
                  ),
                  if (_listProductProperties.isEmpty)
                    const SizedBox(height: sp16),

                  //VariantDefaultView
                  if (_listProductProperties.isEmpty)
                    BlocBuilder<ProductCreateCubit, ProductCreateState>(
                      builder: (context, state) {
                        return VariantDefaultView(
                          title: state.productName,
                          status: state.statusVariantDefault,
                          barcode: state.barCode,
                          priceImport: state.priceImport,
                          priceSell: state.priceSell,
                          amountChange: (value) =>
                              myBloc.variantDefaultChange(amount: value),
                          image: state.imageVariantDefault,
                          imageProducts: state.listImage,
                          imageChange: (image) =>
                              myBloc.variantDefaultChange(image: image),
                          // toggleStatus: myBloc.statusVariantDefaultChange,
                        );
                      },
                    ),
                  const SizedBox(height: sp16),
                  // Product More Info
                  ProductMoreInfoView(
                    expandableControllerMoreInfo: expandableControllerMoreInfo,
                    onSelectCategory: () => getDataProductGroup.call(),
                    myBloc: myBloc,
                    listBrandCtrl: _listBrandCtrl,
                    listcategoryCtrl: _listCategoryCtrl,
                  ),
                  const SizedBox(height: sp16),
                  // product status
                  Container(
                    padding: const EdgeInsets.all(sp16),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(sp8),
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<ProductCreateCubit, ProductCreateState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Trạng thái',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  state.statusProduct
                                      ? 'Đang bán'
                                      : 'Không bán',
                                  style: TextStyle(
                                    color: state.statusProduct
                                        ? mainColor
                                        : greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: sp8),
                                BaseSwitch(
                                  value: state.statusProduct,
                                  onToggle: (value) => context
                                      .read<ProductCreateCubit>()
                                      .statusProductChange(),
                                ),
                              ],
                            );
                          },
                        ),
                        BlocBuilder<ProductCreateCubit, ProductCreateState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                Visibility(
                                  visible: state.statusProduct,
                                  child: const Divider(height: 32),
                                ),
                                Visibility(
                                  visible: state.statusProduct,
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Bán online',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: sp16),
                                      BaseSwitch(
                                        value: state.statusOnline,
                                        onToggle: (value) => context
                                            .read<ProductCreateCubit>()
                                            .statusOnlineChange(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: sp16),
                  BlocBuilder<ProductCreateCubit, ProductCreateState>(
                    builder: (context, state) {
                      return BaseContainer(
                        context,
                        AppInput(
                          label: 'Mô tả sản phẩm',
                          hintText: 'Nhập mô tả',
                          validate: (value) {},
                          textInputType: TextInputType.text,
                          maxLines: 3,
                          // readOnly: true,
                          onChanged: (value) => context
                              .read<ProductCreateCubit>()
                              .descriptionChange(value),
                          // onTap: () =>
                          //     context.router.push(RichTextEditorRoute()),
                        ),
                      );
                    },
                  ),
                  16.height,
                  _configSellUnit(),
                  16.height,
                  _configBaseSellPrice(),
                  16.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormField<Object> _configSellUnit() {
    return FormField(
      validator: (val) {
        if (myBloc.state.listUnit.isEmpty) {
          return 'Chưa cấu hình đơn vị bán';
        }
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Thiết lập đơn vị bán',
                  style: AppStyle.headingLg,
                ),
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.red50,
                  ),
                ),
              ],
            ),
          ),
          12.height,
          if (field.hasError)
            Text(
              field.errorText ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.start,
            ),
          BlocBuilder<ProductCreateCubit, ProductCreateState>(
            builder: (context, state) {
              if (myBloc.state.listUnit.isEmpty) {
                return _buildEmpty();
              }
              return Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: AppColors.ultility_carrot_60,
                        size: 15,
                      ),
                      8.width,
                      Text(
                        'Giá cơ sở',
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  ItemCreateUnit(
                    units: myBloc.state.listUnit,
                    onAdd: configSellUnit,
                    onRemove: (index) {
                      myBloc.removeUnit(index);
                    },
                    onUpdate: (index) {
                      configSellUnit(index: index);
                    },
                    // canEdit: myBloc.state.product?.canEditStock ?? true,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return EmptyComfirm(
      labelBtn: 'Cấu hình đơn vị bán',
      text: 'Chưa cấu hình đơn vị bán',
      onPressed: configSellUnit,
      btnColor: AppColors.button_neutral_solid_backgroundDefault,
    );
  }

  configSellUnit({int? index}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: BtsConfigUnitSell(
            unit: index != null
                ? myBloc.state.listUnit[index]
                : myBloc.state.listUnit.lastOrNull,
            isUpdate: index != null,
            prev: index != null
                ? (index == 0
                    ? '1'
                    : myBloc.state.listUnit[index - 1].name ?? '1')
                : myBloc.state.listUnit.lastOrNull?.name ?? '',
            name: myBloc.state.listUnit.map((e) => e.name.validator).toList(),
          ),
        );
      },
    ).then((value) {
      if (value != null && value is UnitV2Model) {
        if (index != null) {
          myBloc.updateUnit(index, value);
        } else {
          myBloc.addUnit(value);
        }
      }
    });
  }

  Widget _bottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [BoxShadow(color: greyColor.withOpacity(0.2))],
      ),
      padding: const EdgeInsets.all(sp16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Extrabutton(
              title: 'Lưu và tạo thêm',
              event: () => myBloc.createProduct(
                context,
                _listVariantModel,
                listUnit: myBloc.state.listUnit,
                widget.callPreviousPage,
                true,
              ),
              largeButton: true,
              borderColor: borderColor_2,
              icon: null,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 1,
            child: MainButton(
              title: 'Lưu',
              event: () {
                if (!key.currentState!.validate()) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  return;
                }
                myBloc.createProduct(
                  context,
                  _listVariantModel,
                  widget.callPreviousPage,
                  listUnit: myBloc.state.listUnit,
                  false,
                );
              },
              largeButton: true,
              icon: null,
            ),
          ),
        ],
      ),
    );
  }

  void _setFormula() {
    if (_listProductProperties.fold<num>(
          0,
          (previousValue, e) =>
              previousValue + (e.isUse! ? e.value!.length : 0),
        ) !=
        0) {
      // Dựa vào số thuộc tính để tính ra có bao nhiêu phần tử cần tìm
      final num number = _listProductProperties.fold<num>(
        1,
        (total, item) =>
            total *
            (item.value!.isNotEmpty && item.isUse == true
                ? item.value!.length
                : 1),
      );

      // Tạo ra 1 List có length = số phần tử cần tìm
      final arr = List.generate(
        int.parse(number.toString()),
        (index) => PayloadVariantModel(
          title: '',
          barcode: TextEditingController(),
          priceImport: TextEditingController(text: priceImport.text),
          priceSell: TextEditingController(text: priceSell.text),
          nameVariantController:
              TextEditingController(text: nameVariantController.text),
          quantity: TextEditingController(text: '0'),
          options: <Option>[],
          controller: ExpandableController(initialExpanded: true)
            ..addListener(() {
              setState(() {});
            }),
        ),
      );

      num tick = 1;

      // Đưa các giá trị từ thuộc tính vào List đã tạo
      for (final item in _listProductProperties) {
        if (item.value!.isNotEmpty && item.isUse!) {
          tick = tick * item.value!.length;
          int number = 1;
          for (int i = 0; i < arr.length; i++) {
            if (i == (arr.length / tick) * number) number += 1;

            // arr[i].title =
            //     '${payloadProductModel.title!.text} ${item.value![(number - 1) % (item.value!.isEmpty ? 1 : item.value!.length)]}';

            arr[i].title =
                '${arr[i].title}${arr[i].title == '' ? '' : '/'}${item.value![(number - 1) % (item.value!.isEmpty ? 1 : item.value!.length)]}';

            arr[i].options!.add(
                  Option(
                    title: item.name!.text,
                    values: item.value![(number - 1) %
                        (item.value!.isEmpty ? 1 : item.value!.length)],
                  ),
                );
          }
        }
      }
      _listVariantModel = arr;
    } else {
      _listVariantModel = [];
    }
    myBloc.statusVariantDefaultChange(_listProductProperties);
  }

  FormField<Object> _configBaseSellPrice() {
    return FormField(
      validator: (val) {
        final base = myBloc.findBase(myBloc.state.listUnit);
        if (base == null) {
          return 'Chưa cấu hình giá cơ sở';
        }
        return null;
      },
      builder: (field) {
        final base = myBloc.findBase(myBloc.state.listUnit);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Thiết lập giá cơ sở',
                    style: AppStyle.headingLg,
                  ),
                  TextSpan(
                    text: ' *',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.red50,
                    ),
                  ),
                ],
              ),
            ),
            12.height,
            if (field.hasError)
              Text(
                field.errorText ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.start,
              ),
            LabelButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // quan trọng!
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: BtsConfigBasePrice(bloc: myBloc),
                    );
                  },
                ).then((value) {
                  // widget.validate?.call();
                });
              },
              label: 'Thiết lập',
              backgroundColor: AppColors.button_neutral_solid_backgroundDefault,
            ),
            12.height,
            if (myBloc.state.listUnit.isEmpty) Container(),
            if (base != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: 12.radius,
                  border: Border.all(color: AppColors.border_tertiary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: 12.radius,
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Giá mặc định',
                              style: AppStyle.bodyBsMedium,
                            ).expanded(),
                            Text(
                              '${base.name}',
                              style: AppStyle.bodyBsSemiBold,
                            ),
                            8.width,
                          ],
                        ),
                        // BasePriceItem(
                        //   model: base,
                        //   vat: myBloc.state.vat,
                        //   importPrice: myBloc.state.importPrice,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
