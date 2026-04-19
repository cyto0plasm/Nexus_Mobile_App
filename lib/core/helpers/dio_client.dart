import 'package:dio/dio.dart';
import 'package:nexus/core/helpers/token_storage.dart';
import 'package:nexus/constants.dart';

class DioClient {
   static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Accept': 'application/json'},
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    ),
  );

  static void init(){
    dio.options.headers['ngrok-skip-browser-warning']='true';
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options,handler)async{
          final token = await TokenStorage.getToken();

          if(token != null){
            options.headers['Authorization']= 'Bearer $token';
          }
          handler.next(options);
        }
      )
    );

  }
}