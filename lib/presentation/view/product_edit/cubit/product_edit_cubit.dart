import 'dart:convert';
import 'dart:io';

import 'package:base_mykiot/base_lhe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/option_data.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/usecase/category_get_list_use_case.dart';
import 'package:one_click/domain/usecase/product_brand_use_case.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';
import '../../../../data/models/response/base_response.dart';
import '../../../../domain/entity/product_edit_properties.dart';
import '../../../../domain/entity/product_payload.dart';
import '../../../../domain/entity/variant_create_product.dart';
import '../../../../domain/usecase/category_detail_use_case.dart';
import '../../../../domain/usecase/product_edit_use_case.dart';
import '../../../../shared/constants/enum/option_edit_product.dart';
import '../../../../shared/utils/event.dart';
import 'product_edit_state.dart';

@injectable
class ProductEditCubit extends Cubit<ProductEditState> {
  ProductEditCubit(
    this._productBrandUseCase,
    this._productEditUseCase,
    this._categoryGetListUseCase,
    this._categoryDetailUseCase,
  ) : super(const ProductEditState());

  final ProductBrandUseCase _productBrandUseCase;
  final CategoryGetListUseCase _categoryGetListUseCase;
  final ProductEditUseCase _productEditUseCase;
  final CategoryDetailUseCase _categoryDetailUseCase;

  void updateProductDetail(ProductDetailEntity productDetailEntity) {
    emit(state.copyWith(product: productDetailEntity));

    final listProperties = productDetailEntity.properties;
    final listPropertiesEntity = listProperties.map((e) {
      return ProductEditPropertiesEntity(
        name: e.title,
        value: e.childProperties.toSet().toList(),
      );
    }).toList();
    emit(state.copyWith(listProperties: listPropertiesEntity));
  }

  void deletaImagePicker(File file) {
    final imagesPicker = List<File>.from(state.imagesPicker);
    imagesPicker.remove(file);
    emit(state.copyWith(imagesPicker: imagesPicker));
  }

  void deleteMediaData(MediaDataEntity media) {
    final listMedia =
        List<MediaDataEntity>.from(state.product?.mediaData ?? []);
    listMedia.remove(media);
    final product = state.product?.copyWith(mediaData: listMedia);
    emit(state.copyWith(product: product));
  }

  void barcodeChange(String value) {
    final product = state.product?.copyWith(barcode: value);
    emit(state.copyWith(product: product));
  }

  /// This function add more [ProductEditPropertiesEntity]
  ///
  /// This function check length of [state.listProperties] equare 3
  ///
  /// This function only call if [ProductDetailEntity] has only 1 [VariantResponseEntity] also default variant or empty [List] - [ProductEditPropertiesEntity]
  void addPropertie() {
    if (state.listProperties.length == 3) return;
    final list = List<ProductEditPropertiesEntity>.from(state.listProperties);
    list.add(const ProductEditPropertiesEntity());
    emit(state.copyWith(listProperties: list));
  }

  void namePropertieChange(ProductEditPropertiesEntity value, String title) {
    final list = List<ProductEditPropertiesEntity>.from(state.listProperties);
    final index = list.indexWhere((e) => e == value);
    list[index] = list[index].copyWith(name: title);
    emit(state.copyWith(listProperties: list));
    createNewVariant();
    print(state.listProperties);
    print(state.listNewVariant);
  }

  /// This function remove [ProductEditPropertiesEntity]
  void deletePropertie(ProductEditPropertiesEntity value) {
    if (state.listProperties.length == 3) return;
    final list = List<ProductEditPropertiesEntity>.from(state.listProperties);
    list.remove(value);
    emit(state.copyWith(listProperties: list));
  }

  Future<void> productImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 10);
    final imageFile = images.map((e) => File(e.path)).toList();
    var imagesPicker = List<File>.from(state.imagesPicker);
    imagesPicker = imagesPicker + imageFile;
    emit(state.copyWith(imagesPicker: imagesPicker));
  }

  Future<void> initData() async {
    getBrand();
  }
}

extension ProductEvent on ProductEditCubit {
  void productFiledChange({
    int? brandId,
    int? categoryId,
    int? groupId,
    String? description,
    bool? statusProduct,
    bool? statusOnline,
    String? productName,
    String? priceImport,
    String? priceSell,
    String? barcode,
    bool? statusSynchronizedSell,
    bool? statusSynchronizedImport,
  }) {
    final product = state.product?.copyWith(
      barcode: barcode ?? state.product?.barcode ?? '',
      brandId: brandId ?? state.product?.brandId,
      categoryId: categoryId ?? state.product?.categoryId,
      groupId: categoryId == null ? groupId ?? state.product?.groupId : null,
      description: description ?? state.product?.description ?? '',
      statusOnline: statusOnline ?? state.product?.statusOnline ?? false,
      statusProduct: statusProduct ?? state.product?.statusProduct ?? false,
      title: productName ?? state.product?.title ?? '',
      priceImport: double.parse(
        priceImport?.replaceAll('.', '') ??
            state.product?.priceImport.round().toString() ??
            '0',
      ),
      priceSell: double.parse(
        priceSell?.replaceAll('.', '') ??
            state.product?.priceSell.round().toString() ??
            '0',
      ),
    );
    emit(
      state.copyWith(
        product: product,
        statusSynchronizedImport:
            statusSynchronizedImport ?? state.statusSynchronizedImport,
        statusSynchronizedSell:
            statusSynchronizedSell ?? state.statusSynchronizedSell,
      ),
    );
  }
}

extension PropertieEvent on ProductEditCubit {
  void addPropertieValue(ProductEditPropertiesEntity propertie, String value) {
    final listProperties =
        List<ProductEditPropertiesEntity>.from(state.listProperties);
    final index = listProperties.indexWhere((e) => e == propertie);
    final list = List<String>.from(listProperties[index].newValue);
    list.add(value);
    listProperties[index] = listProperties[index].copyWith(newValue: list);
    emit(state.copyWith(listProperties: listProperties));
    createNewVariant();
  }

  void deletePropertieValue(
    ProductEditPropertiesEntity propertie,
    String value,
  ) {
    final listProperties =
        List<ProductEditPropertiesEntity>.from(state.listProperties);
    final index = listProperties.indexWhere((e) => e == propertie);
    final list = List<String>.from(listProperties[index].newValue);
    list.remove(value);
    listProperties[index] = listProperties[index].copyWith(newValue: list);
    emit(state.copyWith(listProperties: listProperties));
    createNewVariant();
  }
}

extension VariantEvent on ProductEditCubit {
  /// Từ List[String] tên các variant mới [state.listTitleNewVariant]
  ///
  /// Sau đó tạo ra mảng [VariantCreateProductEntity]
  void createNewVariant() {
    generateNewTitle();
    final listTitleVariant = List<String>.from(state.listTitleNewVariant);
    final listNewVariantCreateProduct = listTitleVariant.map((e) {
      return VariantCreateProductEntity(
        title: '${state.product?.title ?? ''} $e',
        barcode: state.product?.barcode ?? '',
        priceImport: state.product?.priceImport.round().toString() ?? '0',
        priceSell: state.product?.priceSell.round().toString() ?? '0',
        options: e
            .split('-')
            .map(
              (e) => OptionDataEntity(
                title: state.listProperties
                    .firstWhere(
                      (item) =>
                          item.value.contains(e) || item.newValue.contains(e),
                    )
                    .name,
                values: e,
              ),
            )
            .toList(),
      );
    }).toList();
    emit(state.copyWith(listNewVariant: listNewVariantCreateProduct));
  }

  /// Từ 2 mảng [listTitleAllVariant] và [listTitleOldVariant]
  ///
  /// Tìm ra các phần tử trong mảng [listTitleAllVariant] và không nằm trong [listTitleOldVariant]
  ///
  /// Từ đó tạo ra List[String] là tên các variant mới.
  void generateNewTitle() {
    emit(
      state.copyWith(
        listTitleAllVariant: [],
        listNewVariant: [],
        listTitleOldVariant: [],
      ),
    );

    generateAllTitle(0, '');
    generateOldTitle(0, '');

    final Set<String> set1 = Set<String>.from(state.listTitleAllVariant);
    final Set<String> set2 = Set<String>.from(state.listTitleOldVariant);

    final Set<String> difference =
        set1.union(set2).difference(set1.intersection(set2));

    final List<String> differentElements = difference.toList();

    emit(state.copyWith(listTitleNewVariant: differentElements));
  }

  /// This function create All variant title from Properties Value
  ///
  /// This function return List[String] is name variant
  ///
  /// We use the [generateAllTitle] recursive function to generate the combinations from the [state.listProperties].
  ///
  /// We iterate through each element in the list, get the [state.listProperties.value] list and the [state.listProperties.newValue] list,
  ///
  /// Then iterate over the elements in the value and newValue lists to create the combinations.
  ///
  /// Each time recursively, we update [currentIndex] and [variantName] to build the current combination.
  ///
  /// When [currentIndex] reaches the end of the list, we add the current combination to the [state.listTitleAllVariant].
  void generateAllTitle(int currentIndex, String variantName) {
    if (currentIndex == state.listProperties.length) {
      final listVariant = List<String>.from(state.listTitleAllVariant);
      listVariant.add(variantName);
      emit(state.copyWith(listTitleAllVariant: listVariant));
      return;
    }

    final currentMap = state.listProperties[currentIndex];
    final valueList = currentMap.value + currentMap.newValue;
    // final newValueList = currentMap.newValue;

    for (var i = 0; i < valueList.length; i++) {
      final value = valueList[i];
      final newCombination =
          '${variantName.isEmpty ? '' : '$variantName-'}$value';
      generateAllTitle(currentIndex + 1, newCombination);

      // if (i < newValueList.length) {
      //   final newValue = newValueList[i];
      //   newCombination =
      //       '${variantName.isEmpty ? '' : '$variantName '}$newValue';
      //   generateAllTitle(currentIndex + 1, newCombination);
      // }
    }
  }

  void generateOldTitle(int currentIndex, String variantName) {
    if (currentIndex == state.listProperties.length) {
      final listVariant = List<String>.from(state.listTitleOldVariant);
      listVariant.add(variantName);
      emit(state.copyWith(listTitleOldVariant: listVariant));
      return;
    }

    final currentMap = state.listProperties[currentIndex];
    final valueList = currentMap.value;

    for (var i = 0; i < valueList.length; i++) {
      final value = valueList[i];
      final newCombination =
          '${variantName.isEmpty ? '' : '$variantName-'}$value';
      generateOldTitle(currentIndex + 1, newCombination);
    }
  }

  void variantFieldChange(
    VariantCreateProductEntity variant, {
    String? barcode,
    String? amount,
    String? priceImport,
    String? priceSell,
    File? imageFile,
    bool? isUse,
  }) {
    final list = List<VariantCreateProductEntity>.from(state.listNewVariant);
    final index = list.indexWhere((e) => e == variant);
    list[index] = list[index].copyWith(
      barcode: barcode ?? list[index].barcode,
      quantity: amount ?? list[index].quantity,
      priceImport: priceImport ?? list[index].priceImport,
      priceSell: priceSell ?? list[index].priceSell,
      image: imageFile ?? list[index].image,
      isUse: isUse ?? list[index].isUse,
    );
    emit(state.copyWith(listNewVariant: list));
  }
}

extension ApiEvent on ProductEditCubit {
  Future<void> getBrand() async {
    final input = ProductBrandInput();
    final res = await _productBrandUseCase.execute(input);
    final listDropdonw = (res.baseResponseModel.data ?? [])
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(
              e.title ?? '',
              style: p6,
            ),
          ),
        )
        .toList();
    emit(state.copyWith(listBrandDropdonw: listDropdonw));
  }

  Future<void> getListCategory() async {
    final input = CategoryGetListInput(
      typeCategory: TypeCategory.category,
      page: 1,
      limit: 1000,
      searchKey: '',
      code: 'ALL',
    );
    final res = await _categoryGetListUseCase.execute(input);
    final listDropdonw = (res.response.data as List)
        .map(
          (e) => DropdownMenuItem<int>(
            value: e.id,
            child: Text(
              e.title ?? '',
              style: p6,
            ),
          ),
        )
        .toList();
    emit(state.copyWith(listCategoryDropdonw: listDropdonw));
  }

  Future<void> getListGroup() async {
    if (state.product?.categoryId == null) return;
    final input = CategoryDetailInput(state.product!.categoryId!);
    final res = await _categoryDetailUseCase.execute(input);
    final listDropdonw = (res.response.data?.groupData ?? [])
        .map(
          (e) => DropdownMenuItem<int>(
            value: e.id,
            child: Text(
              e.title,
              style: p6,
            ),
          ),
        )
        .toList();
    emit(state.copyWith(listGroupDropdonw: listDropdonw));
  }

  Future<BaseResponseModel> editProduct() async {
    late OptionEditProduct optionRaw;

    if (state.statusSynchronizedImport && state.statusSynchronizedSell) {
      optionRaw = OptionEditProduct.all;
    } else if (!state.statusSynchronizedImport &&
        state.statusSynchronizedSell) {
      optionRaw = OptionEditProduct.sell;
    } else if (state.statusSynchronizedImport &&
        !state.statusSynchronizedSell) {
      optionRaw = OptionEditProduct.import;
    } else {
      optionRaw = OptionEditProduct.empty;
    }

    final ProductPayloadEntity productPayloadEntity = ProductPayloadEntity(
      brand: state.product?.brandId,
      productGroup: state.product?.groupId,
      productCategory: state.product?.categoryId,
      statusSynchronizedImport: state.statusSynchronizedImport,
      statusSynchronizedSell: state.statusSynchronizedSell,
      product: ProductInfoPayloadEntity(
        title: state.product?.title ?? '',
        barcode: state.product?.barcode ?? '',
        priceSell: formatCurrencyString(
          state.product?.priceSell.round().toString() ?? '0',
        ),
        priceImport: formatCurrencyString(
          state.product?.priceImport.round().toString() ?? '',
        ),
        statusProduct: state.product?.statusProduct ?? false,
        statusOnline: state.product?.statusOnline ?? false,
        description: state.product?.description ?? '',
        option: optionRaw.title,
      ),
      listMediaVariant: state.listNewVariant.fold([], (list, item) {
        list.add(item.isUse && item.image != null);
        return list;
      }),
      variant: state.listNewVariant
          .map(
            (e) => VariantPayloadEntity(
              title: e.title,
              barcode: e.barcode,
              quantity: int.parse(e.quantity),
              priceSell: formatCurrencyString(e.priceSell),
              priceImport: formatCurrencyString(e.priceImport),
              options: e.options
                  .map(
                    (e) => OptionPayloadEntity(
                      title: e.title,
                      values: e.values,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
    // final productPayloadEntity = ProductInfoPayloadEntity(
    //   title: state.product?.title ?? '',
    //   barcode: state.product?.barcode ?? '',
    //   priceSell: formatCurrencyString(
    //     state.product?.priceSell.round().toString() ?? '0',
    //   ),
    //   priceImport: formatCurrencyString(
    //     state.product?.priceImport.round().toString() ?? '',
    //   ),
    //   statusProduct: state.product?.statusProduct ?? false,
    //   statusOnline: state.product?.statusOnline ?? false,
    //   description: state.product?.description ?? '',
    //   option: optionRaw.title,
    // );
    final dataJson = productPayloadEntity.toJson();

    dataJson['media'] = state.product?.mediaData.map((e) => e.id).toList();

    final payload = FormData();

    payload.fields.add(MapEntry('data', jsonEncode(dataJson)));

    for (final e in state.imagesPicker) {
      payload.files
          .add(MapEntry('media_product', await MultipartFile.fromFile(e.path)));
    }

    for (final e in state.listNewVariant) {
      if (e.image != null) {
        payload.files.add(
          MapEntry(
            'media_variant',
            await MultipartFile.fromFile(e.image!.path),
          ),
        );
      }
    }
    final input = ProductEditInput(
      payload,
      state.product?.id ?? 0,
    );
    final res = await _productEditUseCase.execute(input);

    return res.res;
  }
}
