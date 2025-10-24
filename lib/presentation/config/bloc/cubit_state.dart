import 'bloc_status.dart';

class CubitState<T> {
  BlocStatus status;
  bool isFirst;
  T? data;
  String msg;
  int total;

  CubitState({
    this.status = BlocStatus.initial,
    this.total = 0,
    this.data,
    this.isFirst = true,
    this.msg = 'Lỗi. Kết nối tới máy chủ thất bại',
  });

  CubitState<T> copyWith({
    BlocStatus? status,
    T? data,
    String? msg,
    int? total,
    bool? isFirst,
  }) {
    return CubitState(
      status: status ?? this.status,
      data: data,
      msg: msg ?? this.msg,
      total: total ?? this.total,
      isFirst: isFirst ?? this.isFirst,
    );
  }
}
