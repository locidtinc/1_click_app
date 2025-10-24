import 'dart:io';

import 'package:flutter/material.dart';

Widget buildImage(String path) {
  if (path.startsWith('http')) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
    );
  } else {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
    );
  }
}
