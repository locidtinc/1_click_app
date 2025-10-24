class AuthModel {
  int? id;
  String? phone;
  String? fullName;
  String? keyAccount;
  bool? isActive;
  String? systemTitle;

  AuthModel({
    this.id,
    this.phone,
    this.fullName,
    this.keyAccount,
    this.isActive,
    this.systemTitle,
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    fullName = json['full_name'];
    keyAccount = json['key_account'];
    isActive = json['is_active'] ?? false;
    systemTitle = json['system__title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['full_name'] = fullName;
    data['key_account'] = keyAccount;
    data['is_active'] = isActive;
    data['system__title'] = systemTitle;
    return data;
  }
}
