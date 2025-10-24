import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

part 'category_state.freezed.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default('') String searchKey,
    @Default(10) int limit,
    @Default(false) bool isOpenPop,
    @Default(<TypeCategory>[
      TypeCategory.brand,
      TypeCategory.category,
      TypeCategory.group,
    ])
    List<TypeCategory> listOptions,
    @Default(TypeCategory.brand) TypeCategory optionsSelected,
    @Default([
      // FilterButtonItem('Tất cả', 'ALL'),
      FilterButtonItem('Nội bộ', 'CHTH'),
      // FilterButtonItem('MyKios', 'ADMIN'),
    ])
    List<FilterButtonItem> listFilter,
    // @Default(FilterButtonItem('Tất cả', 'ALL')) FilterButtonItem selectFilter,
    @Default(FilterButtonItem('Nội bộ', 'CHTH')) FilterButtonItem selectFilter,
    @Default(BlocStatus.initial) BlocStatus status,
  }) = _CategoryState;
}

/// Dựa vào 3 loại thuộc tính: thương hiệu, ngành hàng, nhóm hàng
///
/// Enum [TypeCategory] sẽ cung cấp tên, endpoint, [PageRouteInfo] phù hợp
///
/// Tên để cung cấp cho giao diện
///
/// Endpoint phục vụ việc giao tiếp với server
///
/// Domain là [https://api.mykiot.com/product/api/]
///
/// routerPage dùng để chuyển hướng trang
enum TypeCategory {
  brand('Thương hiệu', 'productbrand', BrandCreateRoute()),
  category('Ngành hàng', 'productcategory', CreateCategoryRoute()),
  group('Nhóm sản phẩm', 'productgroup', GroupCreateRoute());

  const TypeCategory(this.value, this.endPoint, this.routerPage);
  final String value;
  final String endPoint;
  final PageRouteInfo routerPage;
}
