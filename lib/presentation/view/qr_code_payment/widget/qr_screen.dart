import 'package:flutter/material.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({
    super.key,
    required this.bankAccount,
    required this.bankCode,
    required this.totalFinal,
    required this.code,
  });

  final String? bankAccount;
  final String? bankCode;
  final double? totalFinal;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'https://qr.sepay.vn/img'
        '?acc=${bankAccount ?? ""}'
        '&bank=${bankCode ?? ""}'
        '&amount=${totalFinal?.toString() ?? ""}'
        '&des=${code ?? ""}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          imageUrl,
          errorBuilder: (context, error, stackTrace) {
            return const Text(' Không có ngân hàng');
          },
        ),
      ],
    );
  }
}
