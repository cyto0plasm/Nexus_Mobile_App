
import 'package:nexus/models/shop_model.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;
  final String? role;
  final Shop? shop;

  bool get isAdmin   => role == 'admin';
  bool get isCashier => role == 'cashier';
  bool get hasShop   => shop != null;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.token,
    this.role,   //  optional — null until onboarding
    this.shop,   //  optional — null until onboarding
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:    json['id']?.toString() ?? '',
      name:  json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      role:  json['role'] as String?,                           //  nullable
      shop:  json['shop'] != null                               //  nullable
             ? Shop.fromJson(json['shop'] as Map<String, dynamic>)
             : null,
    );
  }
}