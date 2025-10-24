import 'package:dio/dio.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/usecase/group_create_use_case.dart';

abstract class ProductGroupRepository {
  Future<Response> getList();

  Future<GroupDetailEntity> getProductGroupDetail(int id);

  Future<BaseResponseModel<GroupDetailEntity>> updateProductGroup(
    int id,
    GroupCreateInput payload,
  );
}
