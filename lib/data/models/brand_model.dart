import 'product_category_model.dart';

class BrandModel {
  final int? id;
  final String? title;
  final String? code;
  final String? image;
  final List<int>? product;
  final List<int>? group;
  final SystemData? systemData;
  final int? account;
  final int? productGroupQuantity;

  BrandModel({
    this.id,
    this.title,
    this.code,
    this.image,
    this.product,
    this.group,
    this.systemData,
    this.account,
    this.productGroupQuantity,
  });

  BrandModel copyWith({
    int? id,
    String? title,
    String? code,
    String? image,
    List<int>? product,
    List<int>? group,
    SystemData? systemData,
    int? account,
    int? productGroupQuantity,
  }) =>
      BrandModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        image: image ?? this.image,
        product: product ?? this.product,
        group: group ?? this.group,
        systemData: systemData ?? this.systemData,
        account: account ?? this.account,
        productGroupQuantity: productGroupQuantity ?? this.productGroupQuantity,
      );

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        image: json['image'],
        product: json['product'] == null
            ? []
            : List<int>.from(json['product']!.map((x) => x)),
        group: json['group'] == null
            ? []
            : List<int>.from(json['group']!.map((x) => x)),
        systemData: json['system_data'] == null
            ? null
            : SystemData.fromJson(json['system_data']),
        account: json['account'],
        productGroupQuantity: json['productgroup_quantity'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'image': image,
        'product':
            product == null ? [] : List<dynamic>.from(product!.map((x) => x)),
        'group': group == null ? [] : List<dynamic>.from(group!.map((x) => x)),
        'system_data': systemData?.toJson(),
        'account': account,
        'productgroup_quantity': productGroupQuantity,
      };
}
