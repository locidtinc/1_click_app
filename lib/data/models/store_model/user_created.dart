// To parse this JSON data, do
//
//     final userCreatedModel = userCreatedModelFromJson(jsonString);

import 'dart:convert';

UserCreatedModel userCreatedModelFromJson(String str) => UserCreatedModel.fromJson(json.decode(str));

String userCreatedModelToJson(UserCreatedModel data) => json.encode(data.toJson());

class UserCreatedModel {
    final int? id;
    final String? fullName;
    final Settings? settings;
    final String? keyAccount;

    UserCreatedModel({
        this.id,
        this.fullName,
        this.settings,
        this.keyAccount,
    });

    UserCreatedModel copyWith({
        int? id,
        String? fullName,
        Settings? settings,
        String? keyAccount,
    }) => 
        UserCreatedModel(
            id: id ?? this.id,
            fullName: fullName ?? this.fullName,
            settings: settings ?? this.settings,
            keyAccount: keyAccount ?? this.keyAccount,
        );

    factory UserCreatedModel.fromJson(Map<String, dynamic> json) => UserCreatedModel(
        id: json['id'],
        fullName: json['full_name'],
        settings: json['settings'] == null ? null : Settings.fromJson(json['settings']),
        keyAccount: json['key_account'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'settings': settings?.toJson(),
        'key_account' : keyAccount,
    };
}

class Settings {
    final Npt? npt;

    Settings({
        this.npt,
    });

    Settings copyWith({
        Npt? npt,
    }) => 
        Settings(
            npt: npt ?? this.npt,
        );

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        npt: json['NPT'] == null ? null : Npt.fromJson(json['NPT']),
    );

    Map<String, dynamic> toJson() => {
        'title': npt?.toJson(),
    };
}

class Npt {
    final String? title;

    Npt({
        this.title,
    });

    Npt copyWith({
        String? title,
    }) => 
        Npt(
            title: title ?? this.title,
        );

    factory Npt.fromJson(Map<String, dynamic> json) => Npt(
        title: json['title'],
    );

    Map<String, dynamic> toJson() => {
        'title': title,
    };
}
