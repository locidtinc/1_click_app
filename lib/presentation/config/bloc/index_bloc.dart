import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

class IndexBloc extends Cubit<int> {
  IndexBloc() : super(0);
  DelayCallBack delay = DelayCallBack(delay: 300.milliseconds);
  void change(int val) {
    delay.debounce(() => emit(val));
  }
}
