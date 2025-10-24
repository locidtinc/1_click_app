import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/bloc/bloc_status.dart';
import '../../../config/bloc/init_state.dart';

class LocationMapBloc extends Cubit<CubitState> {
  LocationMapBloc() : super(CubitState());
  final _dio = Dio();
  final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  final latlongUrl = 'https://api.mapbox.com/search/geocode/v6/reverse';
  final param =
      '?country=VN&access_token=pk.eyJ1IjoiY2h1b25na3YiLCJhIjoiY2w4ZWIyM2hxMDdqaDN1bGVtcXZveGNjYSJ9.Y_yECCiFkNFZoCdI9xRUTQ';
//https://api.mapbox.com/search/geocode/v6/reverse?longitude=-73.85769603120909&latitude=40.73197296614026&access_token=YOUR_MAPBOX_ACCESS_TOKEN
  double _lat = 0;
  double get lat => _lat;
  double _lng = 0;
  double get lng => _lng;

  getLatlng({required String address}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final res = await _dio.get('$url/$address.json$param');
      if (res.data != null) {
        _lng = res.data['features'][0]['center'][0];
        _lat = res.data['features'][0]['center'][1];
      }
    } catch (e) {
      print(e);
    }

    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<LatLng> getLocation({required String address}) async {
    try {
      final res = await _dio.get('$url/$address.json$param');
      if (res.data != null) {
        _lng = res.data['features'][0]['center'][0];
        _lat = res.data['features'][0]['center'][1];
      }
    } catch (e) {
      print(e);
    }

    return LatLng(_lat, _lng);
  }

  Future<LatLng> getAddress({required LatLng latLng}) async {
    try {
      final res = await _dio.get(
        '$latlongUrl$param&latitude=${latLng.latitude}&longitude=${latLng.longitude}',
      );
      print('$latlongUrl$param&latitude=${latLng.latitude}&longitude=${latLng.longitude}');
      if (res.data != null) {
        _lng = res.data['features'][0]['center'][0];
        _lat = res.data['features'][0]['center'][1];
      }
    } catch (e) {
      print(e);
    }

    return LatLng(_lat, _lng);
  }
}
