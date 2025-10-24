import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/customer_create.dart';
import 'package:one_click/domain/usecase/customer_create_use_case.dart';

import '../../../routers/router.gr.dart';
import '../../authen/models/confirm_account_payload.dart';
import 'customer_create_state.dart';

@injectable
class CustomerCreateCubit extends Cubit<CustomerCreateState> {
  CustomerCreateCubit(
    this._customerCreateUseCase,
  ) : super(const CustomerCreateState());

  final CustomerCreateUseCase _customerCreateUseCase;

  final List<DropdownMenuItem<int>> listGender = const [
    DropdownMenuItem(value: 1, child: Text('Nam', style: p6)),
    DropdownMenuItem(value: 2, child: Text('Nữ', style: p6)),
    DropdownMenuItem(value: 3, child: Text('Khác', style: p6)),
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void genderChange(int value) {
    emit(state.copyWith(gender: value));
  }

  void birthdayChange(String value) {
    emit(state.copyWith(birthday: value));
  }

  void fullNameChange(String value) {
    emit(state.copyWith(fullName: value));
  }

  void phoneChange(String value) {
    emit(state.copyWith(phone: value));
  }

  void emailChange(String value) {
    emit(state.copyWith(email: value));
  }

  Future<void> avatarCustomerPicker() async {
    final picker = ImagePicker();
    final image = await picker.pickMedia(imageQuality: 50);
    if (image == null) return;
    emit(state.copyWith(avatar: File(image.path)));
  }

  void updateAddress(AddressDataPayload? value) {
    emit(
      state.copyWith(
        addressPayload: value,
      ),
    );
  }
}

extension ApiEvent on CustomerCreateCubit {
  Future<CustomerEntity?> createCustomer(BuildContext context,
      {bool? isCheck = false}) async {
    final validate = formKey.currentState?.validate();
    if (!(validate ?? false)) return null;

    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo khách hàng, vui lòng đợi!',
    );

    final input = CustomerCreateInput(
      CustomerCreateEntity(
        image: state.avatar,
        fullName: state.fullName,
        phone: state.phone,
        gender: state.gender,
        email: state.email,
        birthday: state.birthday,
        address: state.addressPayload?.address ?? '',
        //latLng: state.latLng,
        district: state.addressPayload?.district,
        province: state.addressPayload?.province,
        ward: state.addressPayload?.ward,
        area: state.addressPayload?.area,
        latLng: state.addressPayload?.lat != null &&
                state.addressPayload?.long != null
            ? LatLng(
                state.addressPayload?.lat ?? 0,
                state.addressPayload?.long ?? 0,
              )
            : null,
      ),
    );
    final res = await _customerCreateUseCase.execute(input);

    if (res.responseModel.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      isCheck == true
          ? DialogUtils.showSuccessDialog(
              context,
              content: 'Tạo khách hàng thành công',
              titleConfirm: 'Xác nhận',
              accept: () {
                context.router.popUntil((route) =>
                    route.settings.name == 'OrderCreateConfirmRoute');
              },
            )
          : DialogUtils.showSuccessDialog(
              context,
              content: 'Tạo khách hàng thành công',
              titleClose: 'Trang danh sách',
              titleConfirm: 'Chi tiết',
              accept: () {
                context.router.popUntil(
                    (route) => route.settings.name == 'CustomerListRoute');
                context.router.push(
                  CustomerDetailRoute(customerEntity: res.responseModel.data!),
                );
              },
              close: () {
                context.router.popUntil(
                    (route) => route.settings.name == 'CustomerListRoute');
                Navigator.of(context).pop(res.responseModel.data);
              },
            );
      return res.responseModel.data;
    } else {
      Navigator.of(context).pop();
      DialogUtils.showErrorDialog(
        context,
        content: res.responseModel.message ?? 'Tạo khách hàng thất bại',
      );
    }
    return null;
  }
}

extension GMSEvent on CustomerCreateCubit {
  Future<void> test(BuildContext context) async {
    // const kGoogleApiKey = 'AIzaSyBxNc7ESSs1Re-UiJO2AmAPlI2eyDdHHHg';

    // final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

    // final response =
    //     await places.autocomplete('Nguyễn Ngọc Vũ', types: ['geocode']);
    // print(response.errorMessage);
    // if (response.isOkay) {
    //   final predictions = response.predictions;
    //   // Xử lý danh sách gợi ý tìm kiếm
    //   // Hiển thị danh sách gợi ý tìm kiếm cho người dùng
    //   print('predictions: $predictions');
    // } else {
    //   // Xử lý lỗi
    // }
  }
}
