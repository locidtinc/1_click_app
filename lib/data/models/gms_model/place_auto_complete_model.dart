// To parse this JSON data, do
//
//     final placeAutoCompleteModel = placeAutoCompleteModelFromJson(jsonString);

import 'dart:convert';

PlaceAutoCompleteModel placeAutoCompleteModelFromJson(String str) => PlaceAutoCompleteModel.fromJson(json.decode(str));

String placeAutoCompleteModelToJson(PlaceAutoCompleteModel data) => json.encode(data.toJson());

class PlaceAutoCompleteModel {
    final String? description;
    final List<MatchedSubstring>? matchedSubstrings;
    final String? placeId;
    final String? reference;
    final StructuredFormatting? structuredFormatting;
    final List<Term>? terms;
    final List<String>? types;

    PlaceAutoCompleteModel({
        this.description,
        this.matchedSubstrings,
        this.placeId,
        this.reference,
        this.structuredFormatting,
        this.terms,
        this.types,
    });

    PlaceAutoCompleteModel copyWith({
        String? description,
        List<MatchedSubstring>? matchedSubstrings,
        String? placeId,
        String? reference,
        StructuredFormatting? structuredFormatting,
        List<Term>? terms,
        List<String>? types,
    }) => 
        PlaceAutoCompleteModel(
            description: description ?? this.description,
            matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
            placeId: placeId ?? this.placeId,
            reference: reference ?? this.reference,
            structuredFormatting: structuredFormatting ?? this.structuredFormatting,
            terms: terms ?? this.terms,
            types: types ?? this.types,
        );

    factory PlaceAutoCompleteModel.fromJson(Map<String, dynamic> json) => PlaceAutoCompleteModel(
        description: json["description"],
        matchedSubstrings: json["matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting: json["structured_formatting"] == null ? null : StructuredFormatting.fromJson(json["structured_formatting"]),
        terms: json["terms"] == null ? [] : List<Term>.from(json["terms"]!.map((x) => Term.fromJson(x))),
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "matched_substrings": matchedSubstrings == null ? [] : List<dynamic>.from(matchedSubstrings!.map((x) => x.toJson())),
        "place_id": placeId,
        "reference": reference,
        "structured_formatting": structuredFormatting?.toJson(),
        "terms": terms == null ? [] : List<dynamic>.from(terms!.map((x) => x.toJson())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class MatchedSubstring {
    final int? length;
    final int? offset;

    MatchedSubstring({
        this.length,
        this.offset,
    });

    MatchedSubstring copyWith({
        int? length,
        int? offset,
    }) => 
        MatchedSubstring(
            length: length ?? this.length,
            offset: offset ?? this.offset,
        );

    factory MatchedSubstring.fromJson(Map<String, dynamic> json) => MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
    };
}

class StructuredFormatting {
    final String? mainText;
    final List<MatchedSubstring>? mainTextMatchedSubstrings;
    final String? secondaryText;

    StructuredFormatting({
        this.mainText,
        this.mainTextMatchedSubstrings,
        this.secondaryText,
    });

    StructuredFormatting copyWith({
        String? mainText,
        List<MatchedSubstring>? mainTextMatchedSubstrings,
        String? secondaryText,
    }) => 
        StructuredFormatting(
            mainText: mainText ?? this.mainText,
            mainTextMatchedSubstrings: mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
            secondaryText: secondaryText ?? this.secondaryText,
        );

    factory StructuredFormatting.fromJson(Map<String, dynamic> json) => StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["main_text_matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
    );

    Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": mainTextMatchedSubstrings == null ? [] : List<dynamic>.from(mainTextMatchedSubstrings!.map((x) => x.toJson())),
        "secondary_text": secondaryText,
    };
}

class Term {
    final int? offset;
    final String? value;

    Term({
        this.offset,
        this.value,
    });

    Term copyWith({
        int? offset,
        String? value,
    }) => 
        Term(
            offset: offset ?? this.offset,
            value: value ?? this.value,
        );

    factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json["offset"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "offset": offset,
        "value": value,
    };
}
