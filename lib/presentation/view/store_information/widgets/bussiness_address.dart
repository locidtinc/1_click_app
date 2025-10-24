import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/base/address_empty.dart';

class BussinessAddress extends StatelessWidget {
  const BussinessAddress({
    super.key,
    required this.store,
    this.onTapAddAddress,
    this.onTapEditAddress,
  });

  final StoreEntity store;
  final VoidCallback? onTapAddAddress;
  final VoidCallback? onTapEditAddress;

  @override
  Widget build(BuildContext context) {
    return store.address != null
        ? Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  height: 167,
                  padding: const EdgeInsets.symmetric(horizontal: 4) +
                      const EdgeInsets.only(top: 4, bottom: 24),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(store.address!.lat, store.address!.long),
                      zoom: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            '${AssetsPath.icon}/ic_current_location.svg',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Vị trí hiện tại',
                            style: p6.copyWith(color: borderColor_4),
                          ),
                          const Spacer(),
                          if (onTapEditAddress != null)
                            InkWell(
                              onTap: onTapEditAddress,
                              child: Text(
                                'Chỉnh sửa',
                                style: p5.copyWith(color: blue_1),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        store.address?.title ?? '',
                        style: p5,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          )
        : AddressEmpty(onTapAddAddress: onTapAddAddress);
  }
}
