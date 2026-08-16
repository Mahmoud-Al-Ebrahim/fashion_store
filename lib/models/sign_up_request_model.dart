import 'package:fashion_store/models/store_info_model.dart';
import 'package:fashion_store/models/store_owner_model.dart';
import 'package:fashion_store/models/user_model.dart';

class SignUpRequest {
  final String accountType;

  final String email;
  final String phone;
  final String username;
  final String password;

  final OwnerInfo? owner;

  final NormalUserInfo? normalUser;

  final StoreInfo? store;

  SignUpRequest({
    required this.accountType,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    this.owner,
    this.normalUser,
    this.store,
  });

  Map<String, dynamic> toJson() {
    return {
      "account_type": accountType,
      "email": email,
      "phone": phone,
      "username": username,
      "password": password,
      "owner": owner?.toJson(),
      "normal_user": normalUser?.toJson(),
      "store": store?.toJson(),
    };
  }
}