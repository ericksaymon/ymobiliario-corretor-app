import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/app_models.dart';

class ProfileApiService {
  final Dio _dio = ApiClient.instance.dio;

  Future<AppUser> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/corretores/me');
    return AppUser.fromJson(response.data!);
  }

  Future<AppUser> updateProfile({
    required String nomeFantasia,
    required String telefone,
    required String descricao,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/corretores/me',
      data: {
        'nomeFantasia': nomeFantasia,
        'telefone': telefone,
        'descricao': descricao,
      },
    );
    return AppUser.fromJson(response.data!['corretor'] as Map<String, dynamic>);
  }

  Future<AppUser> updateSocials({
    required String instagram,
    required String facebook,
  }) async {
    await _dio.put(
      '/corretores/me/redes-sociais',
      data: {
        'instagram': instagram.isEmpty ? null : instagram,
        'facebook': facebook.isEmpty ? null : facebook,
      },
    );
    return me();
  }

  Future<AppUser> updatePhoto({
    required String croppedPath,
  }) async {
    final formData = FormData.fromMap({
      'fotoPerfil': await MultipartFile.fromFile(croppedPath),
      'fotoPerfilOriginal': await MultipartFile.fromFile(croppedPath),
    });
    final response = await _dio.put<Map<String, dynamic>>(
      '/corretores/me',
      data: formData,
    );
    return AppUser.fromJson(response.data!['corretor'] as Map<String, dynamic>);
  }

  Future<void> changePassword({
    required String senhaAtual,
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    await _dio.post(
      '/corretores/me/alterar-senha',
      data: {
        'senhaAtual': senhaAtual,
        'novaSenha': novaSenha,
        'confirmarSenha': confirmarSenha,
      },
    );
  }
}
