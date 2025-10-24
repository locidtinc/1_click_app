import 'package:one_click/shared/ext/index.dart';

class ParamDate {
  DateTime? startDate;
  DateTime? endDate;
  DateRangeEnum? dateRange;
  ParamDate({
    this.dateRange = DateRangeEnum.thisMonth,
    this.endDate,
    this.startDate,
  });

  Map<String, dynamic> toJson() {
    //Truyền param kiểu khác
    // return {
    //   if (startDate != null && dateRange == DateRangeEnum.option) 'start_date': startDate.toText(fomat: 'yyyy-MM-dd'),
    //   if (endDate != null && dateRange == DateRangeEnum.option) 'end_date': endDate.toText(fomat: 'yyyy-MM-dd'),
    //   if (dateRange != null && dateRange != DateRangeEnum.option) 'date_range': dateRange?.val,
    // };
    return {
      if (startDate != null)
        'start_date': startDate.toText(fomat: 'yyyy-MM-dd'),
      if (endDate != null) 'end_date': endDate.toText(fomat: 'yyyy-MM-dd'),
      if (dateRange != null && dateRange != DateRangeEnum.option)
        'date_range': dateRange?.val,
    };
  }

  String toText() {
    return '$dateRange : $startDate : $endDate';
  }
}

enum DateRangeEnum {
  all('all'),
  option('option'),
  today('today'),
  yesterday('yesterday'),
  thisWeek('this_week'),
  lastWeek('last_week'),
  thisMonth('this_month'),
  lastMonth('last_month'),
  lastYear('last_year'),
  thisYear('last_year');

  final String val;
  const DateRangeEnum(this.val);
}

extension DateRangeEnumExt on DateRangeEnum {
  String get toName => _convertName();

  String _convertName() {
    switch (this) {
      case DateRangeEnum.today:
        return 'Hôm nay';
      case DateRangeEnum.yesterday:
        return 'Hôm qua';
      case DateRangeEnum.thisWeek:
        return 'Tuần này';
      case DateRangeEnum.lastWeek:
        return 'Tuần trước';
      case DateRangeEnum.thisMonth:
        return 'Tháng này';
      case DateRangeEnum.lastMonth:
        return 'Tháng trước';
      case DateRangeEnum.thisYear:
        return 'Năm nay';
      case DateRangeEnum.lastYear:
        return 'Năm trước';
      case DateRangeEnum.option:
        return 'Tuỳ chọn';
      default:
        return 'Tất cả';
    }
  }
}
