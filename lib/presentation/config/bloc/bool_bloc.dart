import 'package:flutter_bloc/flutter_bloc.dart';

class BoolBloc extends Cubit<bool> {
  BoolBloc() : super(true);

  void toggle({bool? value}) {
    emit(value ?? !state);
  }
}
