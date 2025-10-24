import 'dart:io';

import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';

class ProductImageContainer extends StatelessWidget {
  const ProductImageContainer({
    super.key,
    required this.listMedia,
    required this.listImagePicker,
    required this.deleteMediaData,
    required this.deletaImagePicker,
    required this.productImagePicker,
  });

  /// listMedia là list image được lấy ra từ product detail
  ///
  /// Các phần tử trong list là [MediaDataEntity] - được định nghĩa trong [ProductDetailEntity]
  ///
  /// Sử dụng Image.network để hiển thị ảnh
  final List<MediaDataEntity> listMedia;

  /// listImagePicker được tạo trong quá trình chỉnh sửa sản phẩm
  ///
  /// Các phần tử trong list có type là [File]
  ///
  /// Sử dụng Image.file để hiên thị ảnh
  final List<File> listImagePicker;

  /// deleteMediaData dùng để xoá ảnh trong [List<MediaDataEntity>] [listMedia]
  final Function(MediaDataEntity media) deleteMediaData;

  /// deletaImagePicker dùng để xoá ảnh trong [List<File>] [listImagePicker]
  final Function(File file) deletaImagePicker;

  /// productImagePicker Dùng để upload ảnh từ thư viện
  final Function() productImagePicker;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ảnh sản phẩm',
            style: p1,
          ),
          const SizedBox(
            height: sp24,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: DottedBorder(
                  color: mainColor,
                  borderType: BorderType.RRect,
                  padding: const EdgeInsets.symmetric(vertical: sp16),
                  radius: const Radius.circular(8),
                  dashPattern: const [5, 6],
                  child: Center(
                    child: Text(
                      'Tải ảnh lên(${listMedia.length + listImagePicker.length}/4)',
                      style: p5.copyWith(color: mainColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: sp16),
              GestureDetector(
                onTap: () => productImagePicker(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp16,
                    horizontal: sp16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    border: Border.all(color: mainColor),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: listMedia.isNotEmpty || listImagePicker.isNotEmpty
                    ? sp16
                    : 0,
              ),
              SizedBox(
                height:
                    listMedia.isNotEmpty || listImagePicker.isNotEmpty ? 61 : 0,
                child: Row(
                  children: [
                    ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 61,
                              width: 61,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor_2),
                                borderRadius: BorderRadius.circular(sp8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(sp8),
                                child:
                                    BaseCacheImage(url: listMedia[index].image),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    deleteMediaData.call(listMedia[index]),
                                child: const CircleAvatar(
                                  backgroundColor: mainColor,
                                  radius: sp8,
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: sp12,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: sp16),
                      itemCount: listMedia.length,
                    ),
                    if (listMedia.isNotEmpty) const SizedBox(width: sp16),
                    ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 61,
                              width: 61,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor_2),
                                borderRadius: BorderRadius.circular(sp8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(sp8),
                                child: Image.file(
                                  listImagePicker[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () => deletaImagePicker
                                    .call(listImagePicker[index]),
                                child: const CircleAvatar(
                                  backgroundColor: mainColor,
                                  radius: sp8,
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: sp12,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: sp16),
                      itemCount: listImagePicker.length,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
