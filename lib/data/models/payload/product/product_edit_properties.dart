class ProductEditPropertiesModel {
  ProductEditPropertiesModel({
    this.name,
    this.value,
    this.newValue,
    this.isUse,
    this.id,
  });

  final String? name;
  List<String>? value;
  List<String>? newValue;
  bool? isUse;
  final int? id;

  factory ProductEditPropertiesModel.fromJson(Map<String, dynamic> json) =>
      ProductEditPropertiesModel(
        name: json['name'],
        value: json['value'] == null
            ? []
            : List<String>.from(json['value']!.map((x) => x)),
        isUse: json['isUse'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name!,
        'value': value == null ? [] : List<dynamic>.from(value!.map((x) => x)),
        'isUse': isUse,
        'id': id,
      };
}
