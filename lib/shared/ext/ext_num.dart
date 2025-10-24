part of 'index.dart';

extension extNum on num? {
  num get validator => this ?? 0;
  double get toD => validator.toDouble();
  int get toI => validator.toInt();

  String toDateText({
    String? valDefault,
    String? format,
  }) {
    try {
      final double time = double.tryParse(toString()) ?? 0;
      if (time <= 0) {
        return valDefault ?? '';
      }
      return DateFormat(format ?? 'dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(time.round() * 1000));
    } catch (e) {
      return valDefault ?? '';
    }
  }

  String formatPrice({
    String type = '',
    bool isDefault = true,
  }) {
    if (validator < 0) {
      if (!isDefault) {
        return '';
      }
      return '0$type';
    }
    final formatCurrency = NumberFormat('#,###,###.##', 'vi');
    final String format = formatCurrency.format(validator);
    return format + type;
  }

  DateTime? toDate({bool seconds = false}) {
    return DateTime.fromMillisecondsSinceEpoch(
      validator.round() * (seconds ? 1 : 1000),
    );
  }

  String toPrice({String type = '', String locale = 'vi'}) {
    if ((validator) < 0) {
      return '0$type';
    }
    final formatCurrency = NumberFormat('#,###,###.##', locale);
    final String format = formatCurrency.format(validator);
    return format + type;
  }

  Widget get height => SizedBox(height: toD);
  Widget get width => SizedBox(width: toD);

  BorderRadius get radius => BorderRadius.circular(toD);
  BorderRadius get radiusTop => BorderRadius.vertical(top: Radius.circular(toD));
  BorderRadius get radiusBottom => BorderRadius.vertical(bottom: Radius.circular(toD));

  BorderRadius get radiusLeft => BorderRadius.horizontal(left: Radius.circular(toD));
  BorderRadius get radiusRight => BorderRadius.horizontal(right: Radius.circular(toD));

  BorderRadius get radiusTopLeft => BorderRadius.only(topLeft: Radius.circular(toD));
  BorderRadius get radiusTopRight => BorderRadius.only(topRight: Radius.circular(toD));
  BorderRadius get radiusBottomLeft => BorderRadius.only(bottomLeft: Radius.circular(toD));
  BorderRadius get radiusBottomRight => BorderRadius.only(bottomRight: Radius.circular(toD));

  EdgeInsets get padingTop => EdgeInsets.only(top: toD);
  EdgeInsets get padingLeft => EdgeInsets.only(left: toD);
  EdgeInsets get padingRight => EdgeInsets.only(right: toD);
  EdgeInsets get padingBottom => EdgeInsets.only(bottom: toD);
  EdgeInsets get padingVer => EdgeInsets.symmetric(vertical: toD);
  EdgeInsets get padingHor => EdgeInsets.symmetric(horizontal: toD);
  EdgeInsets get pading => EdgeInsets.all(toD);

  Duration get microseconds => Duration(microseconds: toI);
  Duration get milliseconds => Duration(milliseconds: toI);
  Duration get seconds => Duration(seconds: toI);
  Duration get minutes => Duration(minutes: toI);
  Duration get hours => Duration(hours: toI);
  Duration get days => Duration(days: toI);
}
