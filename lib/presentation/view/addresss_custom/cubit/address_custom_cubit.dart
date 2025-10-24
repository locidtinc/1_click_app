import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';

import '../../../shared_view/address/address_widget.dart';
import 'address_custom_state.dart';

@injectable
class AddressCustomCubit extends Cubit<AddressCustomState> {
  AddressCustomCubit() : super(const AddressCustomState());

  void onFieldChange({String? addressDetail, AddressPayload? addressPayload}) {
    emit(
      state.copyWith(
        addressDetail: addressDetail ?? state.addressDetail,
        addressPayload: addressPayload ?? state.addressPayload,
      ),
    );
  }

  Future<void> tapToOpenBottomSheetAddress(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(_).viewInsets.bottom,
          ),
          child: AddressWidget(
            onDone: (value) {
              emit(state.copyWith(addressPayload: value));
            },
          ),
        );
      },
    );
  }
}
