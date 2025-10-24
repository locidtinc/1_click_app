import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

enum StatusPayment {
  unpaid('Chưa thanh toán', yellow_1),
  qrCode('Đã thanh toán (Chuyển khoản)', green_1),
  cash('Đã thanh toán (Tiền mặt)', green_1);

  const StatusPayment(this.title, this.color);

  final String title;
  final Color color;
}
