import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../routers/router.gr.dart';
import '../../view/map_picker.dart/map_picker_page.dart';

class AddressWithMap extends StatelessWidget {
  const AddressWithMap({
    super.key,
    this.onConfirm,
    this.latLng,
    this.address,
    this.canEdit = true,
  });

  final Function(AddressPickerEntity?, LatLng)? onConfirm;
  final LatLng? latLng;
  final String? address;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sp16),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp8),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 167,
              width: widthDevice(context),
              child: Padding(
                padding: const EdgeInsets.all(sp4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sp4),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: latLng!,
                      zoom: 12,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('addressTitle'),
                        position: latLng!,
                      )
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(sp24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: sp12,
                        backgroundColor: accentColor_4,
                        child: Center(
                          child: Icon(
                            Icons.location_pin,
                            color: mainColor,
                            size: sp16,
                          ),
                        ),
                      ),
                      const SizedBox(width: sp8),
                      Text(
                        'Vị trí hiện tại',
                        style: p6.copyWith(color: borderColor_4),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: canEdit,
                        child: GestureDetector(
                          onTap: () => context.router.push(
                            MapPickerRoute(
                              onConfirm: onConfirm,
                            ),
                          ),
                          child: Text(
                            'Sửa vị trí',
                            style: p5.copyWith(color: blue_1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: sp16),
                  Text(
                    address ?? '',
                    style: p5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
