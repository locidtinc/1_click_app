// To parse this JSON data, do
//
//     final geocodeModel = geocodeModelFromJson(jsonString);

import 'dart:convert';

GeocodeModel geocodeModelFromJson(String str) => GeocodeModel.fromJson(json.decode(str));

String geocodeModelToJson(GeocodeModel data) => json.encode(data.toJson());

class GeocodeModel {
    final List<AddressComponent>? addressComponents;
    final String? formattedAddress;
    final Geometry? geometry;
    final String? placeId;
    final List<String>? types;

    GeocodeModel({
        this.addressComponents,
        this.formattedAddress,
        this.geometry,
        this.placeId,
        this.types,
    });

    GeocodeModel copyWith({
        List<AddressComponent>? addressComponents,
        String? formattedAddress,
        Geometry? geometry,
        String? placeId,
        List<String>? types,
    }) => 
        GeocodeModel(
            addressComponents: addressComponents ?? this.addressComponents,
            formattedAddress: formattedAddress ?? this.formattedAddress,
            geometry: geometry ?? this.geometry,
            placeId: placeId ?? this.placeId,
            types: types ?? this.types,
        );

    factory GeocodeModel.fromJson(Map<String, dynamic> json) => GeocodeModel(
        addressComponents: json['address_components'] == null ? [] : List<AddressComponent>.from(json['address_components']!.map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json['formatted_address'],
        geometry: json['geometry'] == null ? null : Geometry.fromJson(json['geometry']),
        placeId: json['place_id'],
        types: json['types'] == null ? [] : List<String>.from(json['types']!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'address_components': addressComponents == null ? [] : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        'formatted_address': formattedAddress,
        'geometry': geometry?.toJson(),
        'place_id': placeId,
        'types': types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class AddressComponent {
    final String? longName;
    final String? shortName;
    final List<String>? types;

    AddressComponent({
        this.longName,
        this.shortName,
        this.types,
    });

    AddressComponent copyWith({
        String? longName,
        String? shortName,
        List<String>? types,
    }) => 
        AddressComponent(
            longName: longName ?? this.longName,
            shortName: shortName ?? this.shortName,
            types: types ?? this.types,
        );

    factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
        longName: json['long_name'],
        shortName: json['short_name'],
        types: json['types'] == null ? [] : List<String>.from(json['types']!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'long_name': longName,
        'short_name': shortName,
        'types': types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class Geometry {
    final Bounds? bounds;
    final Location? location;
    final String? locationType;
    final Bounds? viewport;

    Geometry({
        this.bounds,
        this.location,
        this.locationType,
        this.viewport,
    });

    Geometry copyWith({
        Bounds? bounds,
        Location? location,
        String? locationType,
        Bounds? viewport,
    }) => 
        Geometry(
            bounds: bounds ?? this.bounds,
            location: location ?? this.location,
            locationType: locationType ?? this.locationType,
            viewport: viewport ?? this.viewport,
        );

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        bounds: json['bounds'] == null ? null : Bounds.fromJson(json['bounds']),
        location: json['location'] == null ? null : Location.fromJson(json['location']),
        locationType: json['location_type'],
        viewport: json['viewport'] == null ? null : Bounds.fromJson(json['viewport']),
    );

    Map<String, dynamic> toJson() => {
        'bounds': bounds?.toJson(),
        'location': location?.toJson(),
        'location_type': locationType,
        'viewport': viewport?.toJson(),
    };
}

class Bounds {
    final Location? northeast;
    final Location? southwest;

    Bounds({
        this.northeast,
        this.southwest,
    });

    Bounds copyWith({
        Location? northeast,
        Location? southwest,
    }) => 
        Bounds(
            northeast: northeast ?? this.northeast,
            southwest: southwest ?? this.southwest,
        );

    factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: json['northeast'] == null ? null : Location.fromJson(json['northeast']),
        southwest: json['southwest'] == null ? null : Location.fromJson(json['southwest']),
    );

    Map<String, dynamic> toJson() => {
        'northeast': northeast?.toJson(),
        'southwest': southwest?.toJson(),
    };
}

class Location {
    final double? lat;
    final double? lng;

    Location({
        this.lat,
        this.lng,
    });

    Location copyWith({
        double? lat,
        double? lng,
    }) => 
        Location(
            lat: lat ?? this.lat,
            lng: lng ?? this.lng,
        );

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat']?.toDouble(),
        lng: json['lng']?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
    };
}
