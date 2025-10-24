import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/card.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@injectable
class GetCardLocalUseCase
    extends BaseUseCase<GetCardLocalInput, GetCardLocalOutput> {
  @override
  GetCardLocalOutput buildUseCase(GetCardLocalInput input) {
    final res = AppSharedPreference.instance.getValue(PrefKeys.card);
    if (res != null) {
      final json = jsonDecode(res as String);
      return GetCardLocalOutput(
        CardEntity.fromJson(json),
      );
    } else {
      return GetCardLocalOutput(null);
    }
  }
}

class GetCardLocalInput extends BaseInput {}

class GetCardLocalOutput extends BaseOutput {
  final CardEntity? card;
  GetCardLocalOutput(this.card);
}
