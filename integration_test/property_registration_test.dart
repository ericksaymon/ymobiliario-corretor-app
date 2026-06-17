import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const baseUrl = 'http://localhost:3001';
  const testEmail = 'joao.silva@teste.com';
  const testPassword = 'Senha@123';

  late Dio dio;
  late String accessToken;

  setUpAll(() async {
    dio = Dio(BaseOptions(baseUrl: baseUrl, validateStatus: (_) => true));

    // Login para obter token
    final loginResponse = await dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': testEmail, 'senha': testPassword},
    );

    expect(loginResponse.statusCode, 200);
    accessToken = loginResponse.data!['accessToken'] as String;
    expect(accessToken, isNotEmpty);
  });

  group('Cadastro de imóvel', () {
    test('deve listar tipos disponíveis', () async {
      final response = await dio.get<Map<String, dynamic>>('/imoveis/tipos');

      expect(response.statusCode, 200);
      expect(response.data, contains('tipos'));
      final tipos = response.data!['tipos'] as List;
      expect(tipos, contains('Residencial'));
      expect(tipos, contains('Rural'));
      expect(tipos, contains('Comercial'));
    });

    test('deve listar subtipos disponíveis', () async {
      final response = await dio.get<Map<String, dynamic>>('/imoveis/subtipos');

      expect(response.statusCode, 200);
      expect(response.data, contains('subtipos'));
      final subtipos = response.data!['subtipos'] as Map<String, dynamic>;
      expect(subtipos, contains('Residencial'));
      expect((subtipos['Residencial'] as List), contains('Casa'));
    });

    test('deve listar bairros disponíveis', () async {
      final response = await dio.get<Map<String, dynamic>>('/imoveis/bairros');

      expect(response.statusCode, 200);
      expect(response.data, contains('bairros'));
    });

    test('deve listar diferenciais disponíveis', () async {
      final response =
          await dio.get<Map<String, dynamic>>('/imoveis/diferenciais');

      expect(response.statusCode, 200);
      expect(response.data, contains('diferenciais'));
    });

    test('deve recusar cadastro sem autenticação', () async {
      final unauthDio = Dio(
        BaseOptions(baseUrl: baseUrl, validateStatus: (_) => true),
      );

      final formData = FormData.fromMap({
        'dados': '{}',
        'thumbnailIndex': '0',
        'imagens': [],
      });

      final response = await unauthDio.post('/imoveis', data: formData);
      expect(response.statusCode, 401);
    });

    test('deve criar imóvel residencial com sucesso', () async {
      // Criar imagens dummy para o teste
      final tempDir = Directory.systemTemp.createTempSync('property_test_');
      final imagePaths = <String>[];
      for (var i = 0; i < 3; i++) {
        final file = File('${tempDir.path}/test_image_$i.jpg');
        // Criar um JPEG mínimo válido (3 bytes SOI marker + padding)
        await file.writeAsBytes([
          0xFF, 0xD8, 0xFF, // JPEG SOI
          ...List.filled(1024, 0x00), // padding
          0xFF, 0xD9, // JPEG EOI
        ]);
        imagePaths.add(file.path);
      }

      final payload = {
        'titulo': 'Casa teste em Centro',
        'descricao': 'Imóvel de teste criado automaticamente pelo integration test',
        'tipo': 'Residencial',
        'subtipo': 'Casa',
        'disponibilidade': 'Venda',
        'exclusividade': 'Compartilhado',
        'rua': 'Rua Teste',
        'numero': '123',
        'bairro': 'Centro',
        'cidade': 'Ariquemes',
        'estado': 'RO',
        'cep': '76800-100',
        'areaTotal': 200.0,
        'preco': 350000.0,
        'aptoFinanciamento': true,
        'aceitaVeiculo': true,
        'aceitaPermuta': false,
        'diferenciais': <String>[],
        'residencial': {
          'condicao': 'Novo',
          'quartos': 3,
          'banheiros': 2,
          'numero_suites': 1,
          'areaConstruida': 180.0,
          'mobiliado': false,
        },
      };

      final formData = FormData.fromMap({
        'dados': payload.toString(),
        'thumbnailIndex': '0',
        'imagens': [
          for (final path in imagePaths)
            await MultipartFile.fromFile(path, filename: 'image.jpg'),
        ],
      });

      final response = await dio.post(
        '/imoveis',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      // Pode retornar 201 (criado) ou 200
      expect(response.statusCode, anyOf(equals(200), equals(201)));
      expect(response.data, isA<Map<String, dynamic>>());
      expect(response.data!['id'], isNotNull);

      final imovelId = response.data!['id'] as String;
      expect(imovelId, isNotEmpty);

      // Limpar: deletar o imóvel criado
      final deleteResponse = await dio.delete(
        '/imoveis/$imovelId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      expect(deleteResponse.statusCode, anyOf(equals(200), equals(204)));

      // Limpar arquivos temporários
      tempDir.deleteSync(recursive: true);
    });

    test('deve listar imóveis do corretor autenticado', () async {
      final response = await dio.get(
        '/imoveis/meus-imoveis',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      expect(response.statusCode, 200);
      expect(response.data, isA<List>());
    });
  });
}
