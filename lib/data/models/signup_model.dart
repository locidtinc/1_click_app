import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/store_model/store_model.dart';

part 'signup_model.g.dart';

@JsonSerializable()
class SignupModel {
  SignupModel(this.token, this.user);

  String? token;
  StoreModel? user;

  factory SignupModel.fromJson(Map<String, dynamic> json) =>
      _$SignupModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignupModelToJson(this);
}
