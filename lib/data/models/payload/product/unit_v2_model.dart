import 'package:one_click/shared/ext/index.dart';

class UnitV2Model {
  int? id;
  String? name;
  int? level;
  bool? sellUnit;
  double? sellPrice;
  double? importPrice;
  double? weight;
  String? weightUnit;
  int? value;
  double? realPrice;
  bool? isDelete;
  int? count;
  double? stockChange;

  UnitV2Model({
    this.id,
    this.name,
    this.level,
    this.sellUnit,
    this.sellPrice,
    this.weight,
    this.weightUnit,
    this.value,
    this.realPrice,
    this.count,
    this.stockChange,
  });

  UnitV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    sellUnit = json['sell_unit'];
    sellPrice = json['sell_price'].toString().parseDouble;
    weight = json['weight'].toString().parseDouble;
    weightUnit = json['weight_unit'];
    value = json['value'];
    stockChange = json['stock_change'].toString().parseDouble;
    realPrice = sellPrice;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['level'] = level;
    data['sell_unit'] = sellUnit;
    data['sell_price'] = sellPrice;
    data['weight'] = weight;
    data['weight_unit'] = weightUnit;
    data['value'] = value;
    data['is_delete'] = isDelete;
    data['stock_change'] = stockChange;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
