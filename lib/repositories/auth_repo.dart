import 'package:dio/dio.dart';
import 'package:nexus/core/helpers/token_storage.dart';
import 'package:nexus/core/helpers/user_storage.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/services/auth_services.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class AuthRepo {
  final AuthServices authServices;

  AuthRepo({required this.authServices});

  AuthException _handleError(dynamic e) {
    if (e is DioException) {
      //check the type first
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return const AuthException(
            'No internet connection. Please try again.',
          );
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const AuthException('Request timed out. Please try again.');
        case DioExceptionType.badResponse:
          final data = e.response?.data;
          final message =
              (data is Map ? data['message'] : null) ?? 'Something went wrong.';
          return AuthException(message);
        default:
          return const AuthException('Something went wrong. Please try again.');
      }
    }
    // Generic Catch - add a case above if another type of error accurs
    return AuthException('Something went wrong. Please try again.');
  }

  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await authServices.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      final body = response['data'];
      final userJson = body['user'];
      final token = body['token'];

      final user = User.fromJson({...userJson, 'token': token, 'shop': body['shop'], 'role': body['role']});


      if (userJson == null || token == null) {
        throw Exception("Invalid response from server");
      }

      await TokenStorage.saveToken(token);
      await UserStorage.saveUser(user);

      return user;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> login({required String email, required String password}) async {
    try {
      final response = await authServices.login(
        email: email,
        password: password,
      );

      final body = response['data'];
      final userJson = body['user'];
      final token = body['token'];

      if (userJson == null || token == null) {
        throw Exception("Invalid response from server");
      }
      final user = User.fromJson({
        ...userJson,
        'token': token,
        'shop': body['shop'],
        'role': body['role'],
      });

      await TokenStorage.saveToken(token);
      await UserStorage.saveUser(user);

      return user;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await authServices.logout();
    } on DioException catch (e) {
      // debugPrint('Logout API failed: ${_handleError(e).message}');
    } finally {
      // token is ALWAYS wiped regardless of server response
      await TokenStorage.clear();
      await UserStorage.clear();
    }
  }
}
