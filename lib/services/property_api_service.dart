import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/app_models.dart';

class PropertyApiService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<PropertyModel>> myProperties({String? status}) async {
    final response = await _dio.get<List<dynamic>>(
      '/imoveis/meus-imoveis',
      queryParameters: {
        if (status != null && status.isNotEmpty && status != 'Todos')
          'status': status,
      },
    );
    return response.data!
        .map((item) => PropertyModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<PropertyModel> getById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/imoveis/$id');
    return PropertyModel.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/imoveis/$id');
  }

  Future<void> changeStatus(String id, String status) async {
    await _dio.patch('/imoveis/$id/status', data: {'status': status});
  }

  Future<List<String>> listBairros() async {
    final response = await _dio.get<Map<String, dynamic>>('/imoveis/bairros');
    return ((response.data?['bairros'] as List?) ?? const [])
        .map((item) => item.toString())
        .toList();
  }

  Future<List<String>> listTipos() async {
    final response = await _dio.get<Map<String, dynamic>>('/imoveis/tipos');
    return ((response.data?['tipos'] as List?) ?? const [])
        .map((item) => item.toString())
        .toList();
  }

  Future<Map<String, List<String>>> listSubtipos() async {
    final response = await _dio.get<Map<String, dynamic>>('/imoveis/subtipos');
    return response.data!.map(
      (key, value) => MapEntry(
        key,
        ((value as List?) ?? const []).map((item) => item.toString()).toList(),
      ),
    );
  }

  Future<List<String>> listDiferenciais() async {
    final response =
        await _dio.get<Map<String, dynamic>>('/imoveis/diferenciais');
    return ((response.data?['diferenciais'] as List?) ?? const [])
        .map((item) => item.toString())
        .toList();
  }

  Future<void> create({
    required Map<String, dynamic> data,
    required List<String> imagePaths,
    required int thumbnailIndex,
  }) async {
    final formData = FormData.fromMap({
      'dados': jsonEncode(data),
      'thumbnailIndex': thumbnailIndex.toString(),
      'imagens': [
        for (final path in imagePaths) await MultipartFile.fromFile(path),
      ],
    });
    await _dio.post('/imoveis', data: formData);
  }

  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    required List<String> newImagePaths,
  }) async {
    final formData = FormData.fromMap({
      'dados': jsonEncode(data),
      if (newImagePaths.isNotEmpty)
        'imagens': [
          for (final path in newImagePaths) await MultipartFile.fromFile(path),
        ],
    });
    await _dio.put('/imoveis/$id', data: formData);
  }
}
