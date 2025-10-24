import 'package:intl/intl.dart';

String formatPrice(num price) {
  if (price == 0) return '0';
  final formatter = NumberFormat('#,###', 'vi_VN');
  return formatter.format(price);
}
