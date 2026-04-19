import 'dart:convert';

import 'package:nexus/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _key = 'current_user';

  //save full user object as JSON
   static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final json = {
      'id':    user.id,
      'name':  user.name,
      'email': user.email,
      'phone': user.phone,
      'token': user.token,
      'role':  user.role,
      'shop':  user.shop != null ? {
        'id':   user.shop!.id,
        'name': user.shop!.name,
      } : null,
    };
    await prefs.setString(_key, jsonEncode(json));
  }

   // load user back — returns null if never saved
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  // wipe on logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
  
}