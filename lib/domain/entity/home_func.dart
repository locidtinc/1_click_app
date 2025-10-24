import 'package:auto_route/auto_route.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_func.freezed.dart';

@freezed
class HomeFuncEntity with _$HomeFuncEntity {
  const HomeFuncEntity._();

  const factory HomeFuncEntity({
    @Default('') String icon,
    @Default('') String title,
    PageRouteInfo? page,
  }) = _HomeFuncEntity;
}
