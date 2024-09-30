import 'package:dio/dio.dart';
import 'token_storage.dart';

class DioClient {
  static Dio createDio() {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // ตั้ง Base URL ของคุณที่นี่
      connectTimeout: const Duration(milliseconds: 10000),  // 10 วินาที
      receiveTimeout: const Duration(milliseconds: 10000),  // 10 วินาที
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // ดึง token จาก TokenStorage
        final token = await TokenStorage().getToken();
        // ตรวจสอบว่ามี token หรือไม่
        if (token != null) {
          // เพิ่ม Authorization header ถ้ามี token
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('Request: ${options.method} ${options.path} | Headers: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // พิมพ์ log ของ response เพื่อช่วยตรวจสอบ
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        // พิมพ์ log ของ error เพื่อช่วยในการ debug
        print('Error: ${error.message}');
        if (error.response != null) {
          print('Error Data: ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));

    return dio;
  }

  post(String s, {required Map<String, String> data}) {}
}
