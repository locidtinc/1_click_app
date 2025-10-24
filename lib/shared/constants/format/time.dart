import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class FormatTime {
  FormatTime();
  Future<String> convertToVietnamTime(String internationalTime) async {
    // Chuyển đổi định dạng giờ từ giờ quốc tế sang múi giờ Việt Nam
    final intlDateFormat =
        DateFormat('h:mm a', 'en_US'); // Định dạng giờ quốc tế
    final vnDateFormat =
        DateFormat('h:mm a', 'vi_VN'); // Định dạng giờ Việt Nam
    final dateTime = intlDateFormat.parse(internationalTime);
    final vnDateTime = dateTime.toLocal();
    return vnDateFormat.format(vnDateTime);
  }

  String convertToVietnamDatetime(DateTime internationalDatetime) {
    // Chuyển đổi định dạng datetime từ quốc tế sang múi giờ Việt Nam
    final vnDateFormat =
        DateFormat('HH:mm - dd/MM/y ', 'vi_VN'); // Định dạng datetime Việt Nam
    final vnDateTime = internationalDatetime.toLocal();
    return vnDateFormat.format(vnDateTime);
  }
}
