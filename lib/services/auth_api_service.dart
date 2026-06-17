import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/app_models.dart';

class AuthApiService {
  final Dio _dio = ApiClient.instance.dio;

  Future<LoginResponseModel> login({
    required String email,
    required String senha,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'senha': senha},
    );
    return LoginResponseModel.fromJson(response.data!);
  }

  Future<void> register({
    required Map<String, dynamic> dados,
    required String fotoCreciFrentePath,
    required String fotoCreciVersoPath,
  }) async {
    final formData = FormData.fromMap({
      'dados': jsonEncode(dados),
      'fotoCreciFrente': await MultipartFile.fromFile(fotoCreciFrentePath),
      'fotoCreciVerso': await MultipartFile.fromFile(fotoCreciVersoPath),
    });

    await _dio.post('/auth/register', data: formData);
  }

  Future<void> sendResetCode(String email) async {
    await _dio.post('/auth/send-reset-code', data: {'email': email});
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await _dio.post(
      '/auth/verify-reset-code',
      data: {'email': email, 'code': code},
    );
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String novaSenha,
  }) async {
    await _dio.post(
      '/auth/reset-password',
      data: {'email': email, 'code': code, 'novaSenha': novaSenha},
    );
  }
}
