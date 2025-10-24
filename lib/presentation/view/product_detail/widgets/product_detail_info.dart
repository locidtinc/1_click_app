import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({
    Key? key,
    required this.product,
    required this.onPressed,
    this.selectedImage = 0,
  }) : super(key: key);

  final ProductDetailEntity product;
  final int selectedImage;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.images.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.23,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor_1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                imageUrl: product.images[selectedImage],
              ),
            ),
          if (product.images.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: 66,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: product.images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onPressed(index),
                    child: Container(
                      width: 66,
                      height: 66,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedImage == index
                              ? mainColor
                              : borderColor_1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                          imageUrl: product.images[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 24),
          Text(
            product.title,
            style: p1,
          ),
          const SizedBox(height: 8),
          Text(
            product.code,
            style: p3.copyWith(color: borderColor_4),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              thickness: 1,
              height: 1,
              color: borderColor_2,
            ),
          ),
          _itemInfo('Mã vạch', product.barcode),
          _itemInfo(
            'Giá bán',
            '${FormatCurrency(product.priceSell)}đ',
          ),
          _itemInfo(
            'Giá nhập',
            '${FormatCurrency(product.priceImport)}đ',
          ),
          _itemInfo('Thương hiệu', product.brand),
          _itemInfo('Ngành hàng', product.productCategory),
          _itemInfo('Nhóm sản phẩm', product.productGroup),
          _classifyProduct(),
        ],
      ),
    );
  }

  Widget _itemInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: p4.copyWith(color: borderColor_4),
          ),
          8.width,
          Flexible(
            child: Text(
              value,
              style: p3,
              maxLines: 2,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _classifyProduct() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: borderColor_1,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Phân loại',
            style: p4.copyWith(color: borderColor_4),
          ),
          Text(
            product.codeSystemData == Api.key ? 'Nội bộ' : 'My Kios',
            style: p3,
          ),
        ],
      ),
    );
  }
}
