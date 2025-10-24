import '../base_use_case.dart';
import '../io/base_input.dart';
import '../io/base_output.dart';

abstract class BaseSyncUseCase<Input extends BaseInput,
    Output extends BaseOutput> extends BaseUseCase<Input, Output> {
  BaseSyncUseCase();

  Output execute(Input input) {
    try {
      final output = buildUseCase(input);
      return output;
    } catch (e) {
      rethrow;
    }
  }
}
