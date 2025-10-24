import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/store_model/bank_data.dart';
import 'package:one_click/presentation/view/add_bank/widgets/cubit/search_bank_state.dart';

@injectable
class SearchBankCubit extends Cubit<SearchBankState> {
  SearchBankCubit() : super(const SearchBankState());

  late List<BankData> _listBankSearch = [];

  void initData(List<BankData> listBank) {
    emit(state.copyWith(listBank: listBank, listBankSearch: listBank));
  }

  void onChanged(String? value) {
    if (value == null || value.isEmpty) {
      emit(state.copyWith(listBankSearch: state.listBank, isEmpty: false));
      return;
    }
    _listBankSearch.clear();
    _listBankSearch = state.listBank
        .where(
          (element) =>
              element.shortName!.toUpperCase().startsWith(value.toUpperCase()),
        )
        .toList();
    emit(
      state.copyWith(
        listBankSearch: _listBankSearch,
        isEmpty: _listBankSearch.isEmpty,
      ),
    );
  }
}
