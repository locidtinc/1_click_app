import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
part 'noti_model.g.dart';

@JsonSerializable()
class NotiModel {
  int? id;
  String? code;
  String? content;
  @JsonKey(name: 'created_at')
  DateTime? createAt;
  @JsonKey(name: 'is_read')
  bool? isReaded;
  @JsonKey(name: 'order_id')
  int? orderId;
  @JsonKey(name: 'type_order')
  String? typeOrder;
  String? title;
  int? index;

  NotiModel({
    this.code,
    this.content,
    this.createAt,
    this.id,
    this.isReaded,
    this.title,
    this.orderId,
    this.typeOrder,
    this.index,
  });

  NotiModel copyWith({
    int? id,
    String? code,
    String? content,
    DateTime? createAt,
    bool? isReaded,
    int? orderId,
    String? typeOrder,
    String? title,
    int? index,
  }) =>
      NotiModel(
        id: id ?? this.id,
        code: code ?? this.code,
        content: content ?? this.content,
        createAt: createAt ?? this.createAt,
        isReaded: isReaded ?? this.isReaded,
        orderId: orderId ?? this.orderId,
        typeOrder: typeOrder ?? this.typeOrder,
        title: title ?? this.title,
        index: index ?? this.index,
      );

  // factory NotiModel.fromJson(dynamic json) => _$NotiModelFromJson(json);

  factory NotiModel.fromJson(dynamic json) => NotiModel(
        id: json['id'],
        content: json['content'],
        createAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        isReaded: json['is_read'],
        title: json['title'],
        code: json['code'],
        orderId: json['order_id'],
        typeOrder: json['type_order'],
        index: json['index'],
      );

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'content': content,
      'created_at': DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSSZ').format(createAt ?? DateTime.now()),
      'is_read': isReaded,
      'notification_id': id,
      'order_id': orderId,
      'title': title,
      'type_order': typeOrder,
      'index': index,
    };
  }
}
