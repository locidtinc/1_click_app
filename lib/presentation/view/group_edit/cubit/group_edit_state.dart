import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';

part 'group_edit_state.freezed.dart';

@freezed
class GroupEditState with _$GroupEditState {
  const factory GroupEditState({
    @Default(null) GroupDetailEntity? groups,
    @Default(<DropdownMenuItem<int>>[])
    List<DropdownMenuItem<int>> listCategory,
    @Default(null) int? productCategory,
  }) = _GroupEditState;
}
