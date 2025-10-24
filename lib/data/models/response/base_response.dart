import 'dart:convert';

BaseResponseModel<T> baseResponseModelFromJson<T>(
  String str,
  T Function(Object? json) fromJsonT,
) =>
    BaseResponseModel<T>.fromJson(json.decode(str), fromJsonT);

String baseResponseModelToJson<T>(
  BaseResponseModel<T> data,
  Object? Function(T value) toJsonT,
) =>
    json.encode(data.toJson(toJsonT));

class BaseResponseModel<T> {
  final int? code;
  final String? message;
  final T? data;
  final dynamic extra;

  BaseResponseModel({
    this.code,
    this.message,
    this.data,
    this.extra,
  });

  BaseResponseModel<T> copyWith({
    int? code,
    String? message,
    T? data,
    dynamic extra,
  }) =>
      BaseResponseModel<T>(
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
        extra: extra ?? this.extra,
      );

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      BaseResponseModel<T>(
        code: json['code'] as int?,
        message: json['message'] as String?,
        data: json['data'] != null ? fromJsonT(json['data']) : null,
        extra: json['extra'],
      );

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
        'code': code,
        'message': message,
        'data': data != null ? toJsonT(data as T) : null,
        'extra': extra,
      };
}
