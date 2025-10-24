import 'package:json_annotation/json_annotation.dart';

part 'warehouse_data_model.g.dart';

@JsonSerializable()
class WarehouseModel {
  final int? id;
  final String? title;
  final String? code;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'status_check')
  final bool? statusCheck;
  final Map<String, dynamic>? settings;
  final int? address;
  @JsonKey(name: 'region_pickup')
  final List<dynamic>? regionPickup;
  @JsonKey(name: 'warehouse_staff')
  final List<dynamic>? warehouseStaff;
  final int? company;
  final int? system;
  @JsonKey(name: 'warehouse_child_data')
  final List<dynamic>? warehouseChildData;
  @JsonKey(name: 'connect_system')
  final int? connectSystem;
  @JsonKey(name: 'type_warehouse')
  final dynamic typeWarehouse;
  @JsonKey(name: 'account_period')
  final dynamic accountPeriod;
  final dynamic parent;
  @JsonKey(name: 'user_manage')
  final dynamic userManage;
  @JsonKey(name: 'user_created')
  final int? userCreated;
  @JsonKey(name: 'user_updated')
  final int? userUpdated;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

 const WarehouseModel({
    this.id,
    this.title,
    this.code,
    this.isActive,
    this.statusCheck,
    this.settings,
    this.address,
    this.regionPickup,
    this.warehouseStaff,
    this.company,
    this.system,
    this.warehouseChildData,
    this.connectSystem,
    this.typeWarehouse,
    this.accountPeriod,
    this.parent,
    this.userManage,
    this.userCreated,
    this.userUpdated,
    this.createdAt,
    this.updatedAt,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => _$WarehouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);

  WarehouseModel copyWith({
    int? id,
    String? title,
    String? code,
    bool? isActive,
    bool? statusCheck,
    Map<String, dynamic>? settings,
    int? address,
    List<dynamic>? regionPickup,
    List<dynamic>? warehouseStaff,
    int? company,
    int? system,
    List<dynamic>? warehouseChildData,
    int? connectSystem,
    dynamic typeWarehouse,
    dynamic accountPeriod,
    dynamic parent,
    dynamic userManage,
    int? userCreated,
    int? userUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WarehouseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      statusCheck: statusCheck ?? this.statusCheck,
      settings: settings ?? this.settings,
      address: address ?? this.address,
      regionPickup: regionPickup ?? this.regionPickup,
      warehouseStaff: warehouseStaff ?? this.warehouseStaff,
      company: company ?? this.company,
      system: system ?? this.system,
      warehouseChildData: warehouseChildData ?? this.warehouseChildData,
      connectSystem: connectSystem ?? this.connectSystem,
      typeWarehouse: typeWarehouse ?? this.typeWarehouse,
      accountPeriod: accountPeriod ?? this.accountPeriod,
      parent: parent ?? this.parent,
      userManage: userManage ?? this.userManage,
      userCreated: userCreated ?? this.userCreated,
      userUpdated: userUpdated ?? this.userUpdated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
