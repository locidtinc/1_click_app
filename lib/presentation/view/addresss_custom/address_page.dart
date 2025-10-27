import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/gen/assets.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/custom_btn.dart';
import 'package:one_click/presentation/base/input_column.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/config/bloc/init_state.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../config/app_style/init_app_style.dart';
import '../authen/models/confirm_account_payload.dart';
import 'cubit/latlng_by_address_bloc.dart';
import 'cubit/location_bloc.dart';

@RoutePage()
class AddressV2Page extends StatefulWidget {
  final AddressDataPayload? address;
  const AddressV2Page({super.key, this.address});

  @override
  State<AddressV2Page> createState() => _AddressV2PageState();
}

class _AddressV2PageState extends State<AddressV2Page> {
  final bloc = LocationBloc();
  final latLongBloc = LatlngByAddressBloc();

  final addressText = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addressText.text = widget.address?.address ?? '';
    bloc.getDataDefault(value: widget.address);
    if (widget.address?.lat != null && widget.address?.long != null) {
      latLongBloc.getLatlng(address: widget.address!.toText);
    }
  }

  @override
  void dispose() {
    addressText.dispose();
    super.dispose();
  }

  MapLatLng? get latLng {
    if (latLongBloc.lat != null && latLongBloc.lng != null) {
      return MapLatLng(latLongBloc.lat!, latLongBloc.lng!);
    } else if (widget.address?.lat != null && widget.address?.long != null) {
      return MapLatLng(widget.address!.lat!, widget.address!.long!);
    }
    return null;
  }

  AddressDataPayload get addressData => AddressDataPayload(
        province: bloc.province?.id,
        district: bloc.district?.id,
        ward: bloc.ward?.id,
        provinceName: bloc.province?.title,
        districtName: bloc.district?.title,
        wardName: bloc.ward?.title,
        area: bloc.area?.id,
        areaName: bloc.area?.title,
        address: addressText.text,
        lat: latLongBloc.lat,
        long: latLongBloc.lng,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyF5,
      appBar: const BaseAppBar(title: 'Địa chỉ'),
      bottomNavigationBar: _btnNav(),
      body: BlocBuilder<LocationBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: 16.pading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<LatlngByAddressBloc, CubitState>(
                      bloc: latLongBloc,
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: 8.radius,
                          ),
                          clipBehavior: Clip.hardEdge,
                          height: 200,
                          child: latLng == null ||
                                  state.status != BlocStatus.success
                              ? Image.asset(
                                  MyAssets.imgsImgMapThumb,
                                  fit: BoxFit.cover,
                                ).radius(4.radius)
                              : SfMaps(
                                  layers: [
                                    MapTileLayer(
                                      initialFocalLatLng: latLng!,
                                      initialZoomLevel: 15,
                                      initialMarkersCount: 1,
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      markerBuilder:
                                          (BuildContext context, int index) {
                                        return MapMarker(
                                          latitude: latLng!.latitude,
                                          longitude: latLng!.longitude,
                                          size: const Size(30, 30),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: mainColor,
                                            size: 30,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ).radius(4.radius),
                        );
                      },
                    ),
                    16.height,
                    Form(
                      key: _keyForm,
                      child: Container(
                        padding: 24.pading,
                        decoration: BoxDecoration(
                          borderRadius: 8.radius,
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CommonDropdown(
                              label: 'Khu vực',
                              required: true,
                              value: bloc.area,
                              onChanged: (p0) {
                                bloc.setArea(p0);
                              },
                              items: List.generate(
                                bloc.areas.length,
                                (index) => DropdownMenuItem(
                                  value: bloc.areas[index],
                                  child: Text(
                                    bloc.areas[index].title ?? '',
                                    style: AppStyle.bodyBsMedium,
                                  ),
                                ),
                              ),
                            ),
                            16.height,
                            CommonDropdown(
                              label: 'Tỉnh/ Thành Phố',
                              required: true,
                              value: bloc.province,
                              onChanged: (p0) {
                                bloc.setProvince(p0);
                              },
                              items: List.generate(
                                bloc.provinces.length,
                                (index) => DropdownMenuItem(
                                  value: bloc.provinces[index],
                                  child: Text(
                                    bloc.provinces[index].title ?? '',
                                    style: AppStyle.bodyBsMedium,
                                  ),
                                ),
                              ),
                            ),
                            16.height,
                            CommonDropdown(
                              label: 'Quận/ Huyện',
                              required: true,
                              value: bloc.district,
                              onChanged: (p0) {
                                bloc.setDistict(p0);
                              },
                              items: List.generate(
                                bloc.districts.length,
                                (index) => DropdownMenuItem(
                                  value: bloc.districts[index],
                                  child: Text(
                                    bloc.districts[index].title ?? '',
                                    style: AppStyle.bodyBsMedium,
                                  ),
                                ),
                              ),
                            ),
                            16.height,
                            CommonDropdown(
                              label: 'Phường/ Xã',
                              required: true,
                              value: bloc.ward,
                              onChanged: (p0) {
                                bloc.setWard(p0);
                              },
                              items: List.generate(
                                bloc.wards.length,
                                (index) => DropdownMenuItem(
                                  value: bloc.wards[index],
                                  child: Text(
                                    bloc.wards[index].title ?? '',
                                    style: AppStyle.bodyBsMedium,
                                  ),
                                ),
                              ),
                            ),
                            16.height,
                            InputColumn(
                              label: 'Địa chỉ chi tiết',
                              isRequired: true,
                              controller: addressText,
                              onChanged: (p0) {
                                bloc.setAddress(p0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    context.padding.bottom.height,
                  ],
                ),
              ),
              if (state.status == BlocStatus.loading && state.isFirst)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: BaseLoading(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _btnNav() {
    return Container(
      padding: 16.pading,
      color: Colors.white,
      child: Row(
        children: [
          CustomBtn(
            title: 'Huỷ bỏ',
            fixedSize: const Size(double.infinity, 45),
            backgroundColor: AppColors.button_brand_alpha_backgroundDisabled,
            onPressed: () => context.pop(),
          ).expanded(),
          16.width,
          CustomBtn(
            fixedSize: const Size(double.infinity, 45),
            title: 'Lưu lại',
            backgroundColor: AppColors.brand,
            textStyle: AppStyle.bodyBsBold.copyWith(
              color: Colors.white,
            ),
            onPressed: () async {
              _keyForm.currentState?.validate();
              if (bloc.addressOk) {
                DialogUtils.showLoadingDialog(context, content: 'Đang tải...');
                await latLongBloc.getLatlng(
                  address: addressData.toText,
                );
                context.pop();
                context.pop(
                  result: addressData,
                );
              }
            },
          ).expanded(),
        ],
      ),
    );
  }
}
