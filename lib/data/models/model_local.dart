import 'package:one_click/shared/constants/param_date.dart';

class ModelLocal<T> {
  String? value;
  String? key;
  int? id;
  T? data;
  DateRangeEnum? dateRange;

  ModelLocal({
    this.key,
    this.value,
    this.data,
    this.id,
    this.dateRange,
  });
}
