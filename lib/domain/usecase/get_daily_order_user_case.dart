// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';

import 'package:one_click/data/mapper/daily_order_mapper.dart';
import 'package:one_click/data/models/daily_oder.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/daily_oder_entity.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetDailyOrderUserCase
    extends BaseFutureUseCase<GetDailyOrderInput, GetDailyOrderOutput> {
  final DailyOrderMapper _dailyOrderMapper;
  final OrderRepository _orderRepository;
  GetDailyOrderUserCase(this._dailyOrderMapper, this._orderRepository);

  @override
  Future<GetDailyOrderOutput<DailyOderEntity>> buildUseCase(
      GetDailyOrderInput input) async {
    final res = await _orderRepository.getDailyOrder(
      input.dateStart,
      input.dateEnd,
    );

    final response = GetDailyOrderOutput<DailyOderEntity>(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: _dailyOrderMapper.mapToEntity(DailyOder.fromJson(res.data)),
      ),
    );
    return response;
  }
}

class GetDailyOrderInput extends BaseInput {
  final DateTime? dateStart;
  final DateTime? dateEnd;
  GetDailyOrderInput({
    this.dateStart,
    this.dateEnd,
  });
}

class GetDailyOrderOutput<T> extends BaseOutput {
  final BaseResponseModel<T> response;
  GetDailyOrderOutput(this.response);
}
