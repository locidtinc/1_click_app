import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/payload/product/product_properties.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:one_click/data/models/payload/product/unit_v2_model.dart';
import 'package:one_click/data/models/unit_model.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/entity/product_payload.dart';
import 'package:one_click/domain/usecase/brand_create_use_case.dart';
import 'package:one_click/domain/usecase/create_category_use_case.dart';
import 'package:one_click/domain/usecase/product_brand_use_case.dart';
import 'package:one_click/domain/usecase/product_by_qrcode.dart';
import 'package:one_click/domain/usecase/product_category_use_case.dart';
import 'package:one_click/domain/usecase/product_create_use_case.dart';
import 'package:one_click/domain/usecase/product_get_barcode_item_use_case.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import '../../../../data/models/payload/product/payload_variant.dart';
import '../../../../domain/usecase/category_detail_use_case.dart';
import '../../../../domain/usecase/create_product_group_use_case.dart';
import '../../../../domain/usecase/product_get_item_use_case.dart';
import '../../../../domain/usecase/product_group_use_case.dart';
import '../../../../shared/utils/event.dart';
import 'product_create_state.dart';

@injectable
class ProductCreateCubit extends Cubit<ProductCreateState> {
  ProductCreateCubit(
    this._productCreateUsecase,
    this._productBrandUseCase,
    this._productCategoryUseCase,
    this._productGroupUseCase,
    this._productByQrcodeUseCase,
    this._categoryDetailUseCase,
    this._createProductGroupUseCase,
    this._createCategoryUseCase,
    this._brandCreateUseCase,
  ) : super(const ProductCreateState());

  final ProductCreateUseCase _productCreateUsecase;
  final ProductBrandUseCase _productBrandUseCase;
  final ProductCategoryUseCase _productCategoryUseCase;
  final ProductGroupUseCase _productGroupUseCase;
  final ProductByQrcodeUseCase _productByQrcodeUseCase;
  final CategoryDetailUseCase _categoryDetailUseCase;
  final CreateProductGroupUseCase _createProductGroupUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final BrandCreateUseCase _brandCreateUseCase;

  final expandedController = ExpandableController(initialExpanded: true);

  Future<void> onInit() async {
    Future.wait([
      getListProductBrand(),
    ]);
  }

  Future<void> createProduct(
    BuildContext context,
    List<PayloadVariantModel> listVariant,
    Function()? onCompleted,
    bool isCreateMore, {
    List<UnitV2Model>? listUnit,
  }) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo sản phẩm, vui lòng đợi!',
    );
    final listUnitAdd = listUnit != null
        ? listUnit
            .map(
              (e) => UntitPayloadEntity(
                title: e.name ?? '',
                level: e.level ?? 0,
                sellUnit: e.sellUnit ?? false,
                conversionValue: e.value ?? 0,
                storageUnit: e.sellUnit ?? false,
              ),
            )
            .toList()
        : <UntitPayloadEntity>[];
    final listVariantAdded = listVariant
        .map(
          (e) => VariantPayloadEntity(
            // title: '${state.productName} ${e.title ?? ''}',
            title: e.nameVariantController?.text ?? '',
            barcode: e.barcode?.text ?? '',
            status: e.isUse,
            quantity: int.parse(e.quantity?.text ?? '0'),
            priceSell: formatCurrencyString(e.priceSell?.text ?? '0'),
            priceImport: formatCurrencyString(e.priceImport?.text ?? '0'),
            options: e.options!
                .map(
                  (e) => OptionPayloadEntity(
                    title: e.title ?? '',
                    values: e.values ?? '',
                  ),
                )
                .toList(),
          ),
        )
        .toList();
    print(
        'state.amountVariantDefault ${int.tryParse(state.amountVariantDefault.trim()) ?? 0}');
    if (state.statusVariantDefault == true) {
      listVariantAdded.add(
        VariantPayloadEntity(
          title: state.productName,
          barcode: state.barCode,
          status: state.statusVariantDefault,
          quantity: int.tryParse(state.amountVariantDefault.trim()) ?? 0,
          priceSell: formatCurrencyString(
            state.priceSell.isEmpty ? '0' : state.priceSell,
          ),
          priceImport: formatCurrencyString(
            state.priceImport.isEmpty ? '0' : state.priceImport,
          ),
        ),
      );
    }

    print('listVariantAdded $listVariantAdded');

    final List<bool> listMediaVariant = listVariant.fold([], (list, item) {
      list.add(item.isUse && item.image != null);
      return list;
    });

    if (state.imageVariantDefault != null) {
      listMediaVariant.add(true);
    }

    final ProductPayloadEntity productPayloadEntity = ProductPayloadEntity(
      brand: state.brand,
      productGroup: state.productgroup,
      productCategory: state.productcategory,
      product: ProductInfoPayloadEntity(
        title: state.productName,
        barcode: state.barCode,
        priceSell: formatCurrencyString(
          state.priceSell.isEmpty ? '0' : state.priceSell,
        ),
        priceImport: formatCurrencyString(
          state.priceImport.isEmpty ? '0' : state.priceImport,
        ),
        statusProduct: state.statusProduct,
        statusOnline: state.statusOnline,
        description: state.productDescreption,
      ),
      listMediaVariant: listMediaVariant,
      variant: listVariantAdded,
      unit: listUnitAdd,
    );

    final payload = FormData();

    payload.fields
        .add(MapEntry('data', jsonEncode(productPayloadEntity.toJson())));

    for (final e in state.listImage) {
      // payload.files.add(MapEntry('media_product', await MultipartFile.fromFile(e.path)));
      if (e.path.startsWith('http')) {
        final downloadedFile = await downloadFile(e.path);
        payload.files.add(
          MapEntry(
            'media_product',
            await MultipartFile.fromFile(downloadedFile.path,
                filename: basename(downloadedFile.path)),
          ),
        );
      } else {
        payload.files.add(
          MapEntry(
            'media_product',
            await MultipartFile.fromFile(e.path, filename: basename(e.path)),
          ),
        );
      }
    }
    for (final e in listVariant) {
      if (e.image != null) {
        final path = e.image!.path;
        if (path.startsWith('http')) {
          final downloadedFile = await downloadFile(path);
          payload.files.add(
            MapEntry(
              'media_variant',
              await MultipartFile.fromFile(downloadedFile.path,
                  filename: basename(downloadedFile.path)),
            ),
          );
        } else {
          payload.files.add(
            MapEntry(
              'media_variant',
              await MultipartFile.fromFile(path, filename: basename(path)),
            ),
          );
        }
      }
    }

    if (state.imageVariantDefault != null) {
      final path = state.imageVariantDefault!.path;
      if (path.startsWith('http')) {
        final downloadedFile = await downloadFile(path);
        payload.files.add(
          MapEntry(
            'media_variant',
            await MultipartFile.fromFile(downloadedFile.path,
                filename: basename(downloadedFile.path)),
          ),
        );
      } else {
        payload.files.add(
          MapEntry(
            'media_variant',
            await MultipartFile.fromFile(path, filename: basename(path)),
          ),
        );
      }
    }
    print('===payload ${payload.fields}');
    final ProductCreateInput input = ProductCreateInput(payload);

    final res = await _productCreateUsecase.execute(input);

    Navigator.of(context).pop();

    if (res.res.code == 200 && context.mounted) {
      final pages =
          context.router.navigatorKey.currentState?.widget.pages ?? [];
      final isProductManagerInStack = pages.any(
        (page) => page.name == ProductManagerRoute.name,
      );

      onCompleted?.call();
      switch (isCreateMore) {
        case true:
          DialogUtils.showSuccessDialog(
            context,
            content: 'Thêm mới sản phẩm thành công',
          );
          Timer(const Duration(milliseconds: 2), () {
            context.router.popUntil(
              (route) => route.settings.name == 'ProductManagerRoute',
            );
            context.router
                .push(ProductCreateRoute(callPreviousPage: onCompleted));
          });
          break;
        default:
          DialogUtils.showSuccessDialog(
            context,
            content: 'Thêm mới sản phẩm thành công',
            // titleConfirm: 'Chi tiết sản phẩm',
            titleConfirm: 'Xác nhận',

            accept: () {
              // if (isProductManagerInStack) {
              //   context.router.popUntil(
              //     (route) => route.settings.name == ProductManagerRoute.name,
              //   );
              //   Future.microtask(() {
              //     context.router.push(ProductDetailRoute(productId: res.res.data?.id ?? 0));
              //   });
              // } else {
              //   context.router.popUntil(
              //     (route) => route.settings.name == QrBottomRoute.name,
              //   );

              //   context.router.push(
              //     ProductDetailRoute(productId: res.res.data?.id ?? 0),
              //   );
              // }
              if (isProductManagerInStack) {
                context.router.popUntil(
                  (route) => route.settings.name == ProductManagerRoute.name,
                );
              } else {
                context.router.popUntil(
                  (route) => route.settings.name == QrBottomRoute.name,
                );
              }
            },
            titleClose: 'Về danh sách',
            close: () {
              if (isProductManagerInStack) {
                context.router.popUntil(
                  (route) => route.settings.name == ProductManagerRoute.name,
                );
              } else {
                context.router.popUntil(
                  (route) => route.settings.name == QrBottomRoute.name,
                );
              }
            },
          );
      }
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Thêm mới sản phẩm thất bại \n ${res.res.message}',
      );
    }
    // Navigator.of(context).pop();
  }

  void statusProductChange() {
    emit(state.copyWith(statusProduct: !state.statusProduct));
  }

  void statusOnlineChange() {
    emit(state.copyWith(statusOnline: !state.statusOnline));
  }

  void statusVariantDefaultChange(List<ProductPropertiesModel> list) {
    final bool isStatus = list.isEmpty ? true : false;
    emit(state.copyWith(statusVariantDefault: isStatus));
  }

  void variantDefaultChange({
    String? amount,
    File? image,
  }) {
    emit(
      state.copyWith(
        amountVariantDefault: amount ?? state.amountVariantDefault,
        imageVariantDefault: image ?? state.imageVariantDefault,
      ),
    );
  }
}

extension ProductImageHandle on ProductCreateCubit {
  Future<void> productImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 10);
    if (images.length > 4) {
      images.removeWhere((e) => images.indexOf(e) > 3);
    }
    emit(
      state.copyWith(
        listImage: images,
        imageVariantDefault: state.listImage.isNotEmpty
            ? File(state.listImage[0].path)
            : images.isNotEmpty
                ? File(images[0].path)
                : null,
      ),
    );
  }

  Future<void> productImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? images =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final listImage = List<XFile>.from(state.listImage);
    if (images != null) {
      listImage.add(images);
      emit(
        state.copyWith(
          listImage: listImage,
          imageVariantDefault: state.listImage.isNotEmpty
              ? File(state.listImage[0].path)
              : File(images.path),
        ),
      );
    }
  }

  void productImageDelete(XFile item) {
    final listImage = [...state.listImage];
    listImage.remove(item);
    // listImage.removeWhere((e) => e.path == item.path);
    emit(state.copyWith(listImage: listImage));
  }
}

extension ProductImageVariantHandle on ProductCreateCubit {
  Future<void> productVariantImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 10);
    if (images.isNotEmpty) {
      images.removeRange(1, images.length);
    }
    emit(
      state.copyWith(
        listVariantImage: images,
        // imageVariantDefault: state.listImage.isNotEmpty
        //     ? File(state.listImage[0].path)
        //     : images.isNotEmpty
        //         ? File(images[0].path)
        //         : null,
      ),
    );
  }

  Future<void> productVariantImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? images =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final listImage = List<XFile>.from(state.listImage);
    if (images != null) {
      listImage.add(images);
      emit(
        state.copyWith(
          listVariantImage: listImage,
          // imageVariantDefault: state.listImage.isNotEmpty ? File(state.listImage[0].path) : File(images.path),
        ),
      );
    }
  }

  void productVariantImageDelete(XFile item) {
    final listImage = [...state.listImage];
    listImage.remove(item);
    // listImage.removeWhere((e) => e.path == item.path);
    emit(state.copyWith(listVariantImage: listImage));
  }
}

extension ProductInfoHandle on ProductCreateCubit {
  void productNameChange(String value) {
    emit(state.copyWith(productName: value));
  }

  void barCodeChange(String value) {
    emit(state.copyWith(barCode: value));
  }

  void priceSellChange(String value) {
    emit(state.copyWith(priceSell: value));
  }

  void priceImportChange(String value) {
    emit(state.copyWith(priceImport: value));
  }

  void descriptionChange(String value) {
    emit(state.copyWith(productDescreption: value));
  }
}

extension PropertieHandle on ProductCreateCubit {
  void addPropertieValue() {}

  void addPropertie() {}
}

int _page = 1;

extension ProductBrandHandle on ProductCreateCubit {
  Future<List<BrandEntity>> getListProductBrand({
    String? search,
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
    }
    final res = await _productBrandUseCase.execute(
      ProductBrandInput(
        page: _page,
        search: search,
      ),
    );

    final listDropdonw = (res.baseResponseModel.data ?? [])
        .map((e) => BrandEntity(title: e.title ?? '', id: e.id))
        .toList();

    emit(
      state.copyWith(
        listBrand:
            isMore ? [...state.listBrand, ...listDropdonw] : listDropdonw,
      ),
    );

    return listDropdonw;
  }

  Future<void> createBrand(String title) async {
    final input = BrandCreateInput(
      group: [],
      product: [],
      title: title,
      productBrand: [],
    );
    final res = await _brandCreateUseCase.execute(input);
    final list = List<BrandEntity>.from(state.listCategory);
    list.add(
      BrandEntity(
        id: res.response.data?.id,
        title: res.response.data?.title ?? '',
      ),
    );
    emit(
      state.copyWith(
        listBrand: list,
        brand: res.response.data?.id,
      ),
    );
  }

  void brandChange(int? id) {
    emit(state.copyWith(brand: id));
  }
}

extension ProductCategoryHandle on ProductCreateCubit {
  Future<List<BrandEntity>> getListProductCategory({
    String? search,
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
    }

    final res = await _productCategoryUseCase.execute(
      ProductCategoryInput(
        page: _page,
        search: search,
      ),
    );

    final listDropdonw = (res.response.data ?? [])
        .map(
          (e) => BrandEntity(
            title: e.title ?? '',
            id: e.id,
          ),
        )
        .toList();
    emit(
      state.copyWith(
        listCategory:
            isMore ? [...state.listCategory, ...listDropdonw] : listDropdonw,
      ),
    );

    return listDropdonw;
  }

  Future<void> createCategory(String title) async {
    final input = CreateCategoryUseCaseInput(
      title,
      [],
    );
    final res = await _createCategoryUseCase.execute(input);
    final list = List<BrandEntity>.from(state.listCategory);
    list.add(BrandEntity(id: res.data?.id, title: res.data?.title ?? ''));
    emit(
      state.copyWith(
        listCategory: list,
        productcategory: res.data?.id,
      ),
    );
  }

  void categoryChange(int? id) {
    emit(state.copyWith(productcategory: id));
  }
}

extension ProductGroupHandle on ProductCreateCubit {
  Future<List<DropdownMenuItem>> getListProductGroup() async {
    final input = CategoryDetailInput(state.productcategory ?? 0);
    final res = await _categoryDetailUseCase.execute(input);
    final listDropdonw = (res.response.data?.groupData ?? [])
        .map(
          (e) => BrandEntity(
            title: e.title,
            id: e.id,
          ),
        )
        .toList();
    emit(state.copyWith(listGroup: listDropdonw));
    return [];
  }

  Future<void> createGroup(String title) async {
    final input = CreateProductGroupInput(
      product: [],
      productCategory: state.productcategory,
      title: title,
    );
    final res = await _createProductGroupUseCase.execute(input);
    final list = List<BrandEntity>.from(state.listGroup);
    list.add(BrandEntity(id: res.data?.id, title: res.data?.title ?? ''));
    emit(
      state.copyWith(
        listGroup: list,
        productgroup: res.data?.id,
      ),
    );
  }

  void groupChange(int? id) {
    emit(state.copyWith(productgroup: id));
  }
}

extension ProductScan on ProductCreateCubit {
  Future<void> getProductByScan(String? barCode) async {
    final input = ProductByQrcodeInput(barCode);
    final res = await _productByQrcodeUseCase.execute(input);
    emit(state.copyWith(listProductScan: res.response.data ?? []));
  }

  Future<ProductDetailEntity> getDetail(int? id) async {
    final input = ProductDetailInput(id ?? -1);
    final res = await getIt<ProductGetItemUseCase>().buildUseCase(input);

    return res.productDetailEntity;
  }

  Future<ProductDetailEntity> getProductDetailV2(int? id) async {
    final input = ProductBarcodeDetailInput(id ?? -1);
    final res = await getIt<ProductGetBarcodeItemUseCase>().buildUseCase(input);

    return res.productDetailEntity;
  }

  void selectProductScan(ProductDetailEntity product) {
    emit(
      state.copyWith(
        productName: product.title,
        barCode: product.barcode,
        priceSell: product.priceSell.round().toString(),
        priceImport: product.priceImport.round().toString(),
        statusProduct: product.statusProduct,
        statusOnline: product.statusOnline,
        productDescreption: product.description,
        brand: product.brandId,
        productgroup: product.groupId,
        productcategory: product.categoryId,
        listImage: product.images.map((path) => XFile(path)).toList(),
      ),
    );

    if (product.categoryId != null) {
      getListProductGroup();
    }
  }

  Future<File> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${basename(url)}';
    final file = File(filePath);
    return await file.writeAsBytes(response.bodyBytes);
  }
// ConfigSell

  void setVAT(double value) {
    emit(state.copyWith(vat: value));
  }

  void setImportPrice(double value) {
    emit(state.copyWith(importPrice: value));
  }

  void setList(List<UnitV2Model> list) {
    emit(state.copyWith(listUnit: List<UnitV2Model>.from(list)));
  }

  void setListDelete(List<UnitV2Model> list) {
    emit(state.copyWith(listDelete: List<UnitV2Model>.from(list)));
  }

  void addDelete(UnitV2Model value) {
    value.isDelete = true;
    final updated = List<UnitV2Model>.from(state.listDelete)..add(value);
    emit(state.copyWith(listDelete: updated));
  }

  void addUnit(UnitV2Model value) {
    final updated = List<UnitV2Model>.from(state.listUnit)..add(value);
    emit(state.copyWith(listUnit: updated));
  }

  void updateUnit(int index, UnitV2Model value) {
    final updated = List<UnitV2Model>.from(state.listUnit);
    updated[index] = value;

    final base = findBase(updated);
    if (base != null) {
      _updatePrices(updated, base.level ?? -1, base.sellPrice ?? 0,
          base.importPrice ?? 0);
    }

    emit(state.copyWith(listUnit: updated));
  }

  void removeUnit(int index) {
    final updated = List<UnitV2Model>.from(state.listUnit);
    final deleted = List<UnitV2Model>.from(state.listDelete);

    for (int i = index + 1; i < updated.length; i++) {
      updated[i].level = (updated[i].level ?? 0) - 1;
    }

    final removed = updated.removeAt(index);
    removed.isDelete = true;
    deleted.add(removed);

    final base = findBase(updated);
    if (base != null) {
      _updatePrices(updated, base.level ?? -1, base.sellPrice ?? 0,
          base.importPrice ?? 0);
    }

    emit(state.copyWith(listUnit: updated, listDelete: deleted));
  }

  void updatePrices(int level, double sell, double import, double vat) {
    final updated = List<UnitV2Model>.from(state.listUnit);
    _updatePrices(updated, level, sell, import, vat);
    emit(state.copyWith(listUnit: updated));
  }

  // === PRIVATE ===

  UnitV2Model? findBase(List<UnitV2Model> list) {
    return list.firstWhereOrNull((e) => e.sellUnit ?? false);
  }

  void _updatePrices(
      List<UnitV2Model> list, int level, double sell, double import,
      [double vat = 0]) {
    final index = list.indexWhere((e) => e.level == level);
    if (index == -1) return;

    list[index]
      ..sellPrice = sell
      ..importPrice = import
      ..sellUnit = true;

    for (int i = index + 1; i < list.length; i++) {
      list[i]
        ..sellPrice = (list[i - 1].sellPrice ?? 0) / (list[i].value ?? 1)
        ..sellUnit = false;
    }

    for (int i = index - 1; i >= 0; i--) {
      list[i]
        ..sellPrice = (list[i + 1].sellPrice ?? 0) * (list[i + 1].value ?? 1)
        ..sellUnit = false;
    }
  }
}
