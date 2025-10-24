// import 'package:auto_route/auto_route.dart';
// import 'package:base_mykiot/base_lhe.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:one_click/domain/entity/store_information_payload.dart';
// import 'package:one_click/presentation/base/app_bar.dart';
// import 'package:one_click/presentation/di/di.dart';
// import 'package:one_click/presentation/view/addresss_custom/cubit/address_custom_state.dart';

// import 'cubit/address_custom_cubit.dart';

// @RoutePage()
// class AddressCustomerPage extends StatefulWidget {
//   const AddressCustomerPage({super.key, this.onConfirm});

//   final Function(AddressPayload? value)? onConfirm;

//   @override
//   State<AddressCustomerPage> createState() => _AddressCustomerPageState();
// }

// class _AddressCustomerPageState extends State<AddressCustomerPage> {
//   late TextEditingController _addressDetailTec;

//   final myBloc = getIt.get<AddressCustomCubit>();

//   @override
//   void initState() {
//     super.initState();

//     _addressDetailTec = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AddressCustomCubit>(
//       create: (context) => myBloc,
//       child: Scaffold(
//         backgroundColor: bg_4,
//         appBar: const BaseAppBar(title: 'Địa chỉ'),
//         body: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: SingleChildScrollView(
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
//               height: heightDevice(context),
//               width: widthDevice(context),
//               child: Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       // context.router.push(
//                       //   MapPickerRoute(
//                       //     addressInit: AddressPickerEntity(
//                       //       title: myBloc.state.addressPayload?.title,
//                       //       provinceName:
//                       //           myBloc.state.addressPayload?.provinceName,
//                       //       districtName:
//                       //           myBloc.state.addressPayload?.districtName,
//                       //       wardName: myBloc.state.addressPayload?.wardName,
//                       //     ),
//                       //     onConfirm: (address, latlng) => myBloc.onFieldChange(
//                       //       addressPayload: AddressPayload(
//                       //         title: address?.title ?? '',
//                       //         lat: latlng.latitude,
//                       //         long: latlng.longitude,
//                       //         province: address?.provinceId ?? 0,
//                       //         provinceName: address?.provinceName ?? '',
//                       //         district: address?.districtId ?? 0,
//                       //         districtName: address?.districtName ?? '',
//                       //         ward: address?.wardId ?? 0,
//                       //         wardName: address?.wardName ?? '',
//                       //       ),
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: whiteColor, width: 5),
//                         borderRadius: BorderRadius.circular(sp8),
//                       ),
//                       width: double.infinity,
//                       height: 200,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(sp8),
//                         child: Image.asset(
//                           '${AssetsPath.image}/img_map_thumb.jpeg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: sp16),
//                   BlocBuilder<AddressCustomCubit, AddressCustomState>(
//                     builder: (context, state) {
//                       if (_addressDetailTec.text != state.addressPayload?.title) {
//                         _addressDetailTec.text = state.addressPayload?.title ?? '';
//                       }
//                       print(state.addressPayload?.title);
//                       return BaseContainer(
//                         context,
//                         Padding(
//                           padding: const EdgeInsets.all(sp8),
//                           child: Column(
//                             children: [
//                               AppInput(
//                                 controller: TextEditingController(
//                                   text: state.addressPayload?.provinceName ?? '',
//                                 ),
//                                 label: 'Tỉnh/ Thành phố',
//                                 hintText: 'Nhấn để chọn tỉnh/ thành phố',
//                                 validate: (value) {},
//                                 required: true,
//                                 suffixIcon: const Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   size: sp24,
//                                 ),
//                                 readOnly: true,
//                                 onTap: () => myBloc.tapToOpenBottomSheetAddress(context),
//                               ),
//                               const SizedBox(height: sp16),
//                               AppInput(
//                                 controller: TextEditingController(
//                                   text: state.addressPayload?.districtName ?? '',
//                                 ),
//                                 label: 'Quận/ Huyện',
//                                 hintText: 'Nhấn để chọn Quận/ Huyện',
//                                 validate: (value) {},
//                                 required: true,
//                                 suffixIcon: const Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   size: sp24,
//                                 ),
//                                 readOnly: true,
//                                 onTap: () => myBloc.tapToOpenBottomSheetAddress(context),
//                               ),
//                               const SizedBox(height: sp16),
//                               AppInput(
//                                 controller: TextEditingController(
//                                   text: state.addressPayload?.wardName ?? '',
//                                 ),
//                                 label: 'Phường/ Xã',
//                                 hintText: 'Nhấn để chọn Phường/ Xã',
//                                 validate: (value) {},
//                                 required: true,
//                                 suffixIcon: const Icon(
//                                   Icons.arrow_drop_down_rounded,
//                                   size: sp24,
//                                 ),
//                                 readOnly: true,
//                                 onTap: () => myBloc.tapToOpenBottomSheetAddress(context),
//                               ),
//                               const SizedBox(height: sp16),
//                               AppInput(
//                                 // initialValue: state.addressPayload?.title,
//                                 controller: _addressDetailTec,
//                                 label: 'Địa chỉ chi tiết',
//                                 hintText: 'Nhập địa chi tiết',
//                                 validate: (value) {},
//                                 required: true,
//                                 onChanged: (value) => myBloc.onFieldChange(
//                                   addressDetail: value,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: Container(
//           color: whiteColor,
//           padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Extrabutton(
//                   title: 'Huỷ bỏ',
//                   event: () => context.router.pop(),
//                   largeButton: true,
//                   borderColor: borderColor_2,
//                   icon: null,
//                 ),
//               ),
//               const SizedBox(width: sp16),
//               Expanded(
//                 flex: 1,
//                 child: MainButton(
//                   title: 'Lưu lại',
//                   event: () {
//                     widget.onConfirm?.call(myBloc.state.addressPayload);
//                     context.router.pop();
//                   },
//                   largeButton: true,
//                   icon: null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
