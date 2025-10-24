import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/data/models/model_local.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/config/bloc/cubit_state.dart';

class DateTimeBloc extends Cubit<CubitState> {
  DateTimeBloc() : super(CubitState());

  DateTime? _start;
  DateTime? _end;
  DateTime? get start => _start;
  DateTime? get end => _end;
  final DateTime _now = DateTime.now();

  final List<ModelLocal> optionDateTime = [
    ModelLocal(
      key: 'today',
      value: 'Hôm nay',
    ),
    ModelLocal(
      key: 'yesterday',
      value: 'Hôm qua',
    ),
    ModelLocal(
      key: '7-day-ago',
      value: '7 ngày trước',
    ),
    ModelLocal(
      key: '30-day-ago',
      value: '30 ngày trước',
    ),
    ModelLocal(
      key: 'last-week',
      value: 'Tuần trước',
    ),
    ModelLocal(
      key: 'last-month',
      value: 'Tháng trước',
    ),
    ModelLocal(
      key: 'all',
      value: 'Tất cả',
    ),
    ModelLocal(
      key: 'option',
      value: 'Tuỳ chọn',
    ),
  ];
  back() {
    emit(
      state.copyWith(status: BlocStatus.initial),
    );
  }

  chooseBtn(ModelLocal item) {
    _end = DateTime(_now.year, _now.month, _now.day - 1, 23, 59);
    if (item.key == optionDateTime.first.key) {
      _start = DateTime(_now.year, _now.month, _now.day);
      _end = _now;
    } else if (item.key == optionDateTime[1].key) {
      _start = DateTime(_now.year, _now.month, _now.day - 1);
    } else if (item.key == optionDateTime[2].key) {
      _start = DateTime(_now.year, _now.month, _now.day - 7);
    } else if (item.key == optionDateTime[3].key) {
      _start = DateTime(_now.year, _now.month, _now.day - 30);
    } else if (item.key == optionDateTime[4].key) {
      _getLastWeek();
    } else if (item.key == optionDateTime[5].key) {
      _getLastMonth();
    } else {
      _start = null;
      _end = null;
    }
    item.data = [_start, _end];
    emit(
      state.copyWith(
        status: BlocStatus.success,
        data: item,
      ),
    );

    print('${item.value} - Start: $_start <==> End: $_end');
  }

  _getLastWeek() {
    // Xác định ngày của tuần (1: Thứ 2, 2: Thứ 3, ..., 7: Chủ nhật)
    final int currentWeekday = _now.weekday;

    // Trừ đi số ngày tương ứng để lấy ngày giờ từ thứ 2 đến chủ nhật của tuần trước
    final DateTime mondayOfLastWeek =
        _now.subtract(Duration(days: currentWeekday + 6));
    final DateTime sundayOfLastWeek =
        _now.subtract(Duration(days: currentWeekday));

    _start = DateTime(
      mondayOfLastWeek.year,
      mondayOfLastWeek.month,
      mondayOfLastWeek.day,
    );
    _end = DateTime(
      sundayOfLastWeek.year,
      sundayOfLastWeek.month,
      sundayOfLastWeek.day,
    );

    print('now: $_now');
    print('Monday of last week: $mondayOfLastWeek');
    print('Sunday of last week: $sundayOfLastWeek');
  }

  _getLastMonth() {
    // Xác định ngày của tuần (1: Thứ 2, 2: Thứ 3, ..., 7: Chủ nhật)
    // Ngày đầu tháng hiện tại
    final DateTime firstDayOfCurrentMonth = DateTime(_now.year, _now.month, 1);

    // Ngày cuối tháng trước đó
    final DateTime lastDayOfPreviousMonth =
        firstDayOfCurrentMonth.subtract(const Duration(days: 1));

    _start = DateTime(
      lastDayOfPreviousMonth.year,
      lastDayOfPreviousMonth.month,
      1,
    );
    _end = DateTime(
      lastDayOfPreviousMonth.year,
      lastDayOfPreviousMonth.month,
      lastDayOfPreviousMonth.day,
    );

    print('now: $_now');
    print('First day of current month: $firstDayOfCurrentMonth');
    print('First day of previous month: $_start');
    print('Last day of previous month: $lastDayOfPreviousMonth');
  }
}
