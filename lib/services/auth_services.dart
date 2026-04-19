import 'package:dio/dio.dart';
import 'package:nexus/core/helpers/dio_client.dart';
import 'package:nexus/models/user_model.dart';

class AuthServices {
    final Dio dio = DioClient.dio;

  Future<Map<String, dynamic>> register({
  required String name,
  required String email,
  required String phone,
  required String password,
  required String passwordConfirmation,
}) async {
  print('📡 Hitting: ${dio.options.baseUrl}user/register');
  final response = await dio.post(
    'user/register',
    data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    },
  );
 print('📦 Response: ${response.data}');
  return response.data as Map<String, dynamic>;
}


Future <Map<String,dynamic>> login({
   required String email,
  required String password,
})async{
    final response = await dio.post(
    'user/login',
    data: {
      'email': email,
      'password': password,
    },
  );

  return response.data as Map<String, dynamic>;
  
}

Future <Map<String, dynamic>> logout()async{
  final response = await dio.post('user/logout');
  return response.data as Map<String, dynamic>;
}
}