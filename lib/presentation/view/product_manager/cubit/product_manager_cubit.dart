import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/presentation/view/product_manager/cubit/product_manager_state.dart';

import '../../../../domain/entity/product_tab.dart';
import '../child/category/category_page.dart';
import '../child/product/product_page.dart';

@injectable
class ProductManagerCubit extends Cubit<ProductManagerState> {
  ProductManagerCubit() : super(const ProductManagerState());

  final List<ProductTab> listTab = [
    const ProductTab(
      title: 'Sản phẩm',
      page: ProductView(),
    ),
    const ProductTab(
      title: 'Danh mục',
      page: CategoryView(),
    )
  ];
}
