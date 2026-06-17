import 'package:flutter_test/flutter_test.dart';
import 'package:ymobiliario_corretor_app/models/app_models.dart';

void main() {
  group('PropertyModel', () {
    test('deve parsear JSON de imóvel residencial', () {
      final json = {
        'id': 'test-id-123',
        'titulo': 'Casa em Centro',
        'tipo': 'Residencial',
        'subtipo': 'Casa',
        'disponibilidade': 'Venda',
        'status': 'Ativo',
        'bairro': 'Centro',
        'cidade': 'Ariquemes',
        'estado': 'RO',
        'descricao': 'Descrição do imóvel para teste',
        'preco': 350000.0,
        'areaTotal': 200.0,
        'rua': 'Rua Teste',
        'numero': '123',
        'cep': '76800-100',
        'residencial': {
          'condicao': 'Novo',
          'quartos': 3,
          'banheiros': 2,
          'numero_suites': 1,
          'areaConstruida': 180.0,
          'mobiliado': false,
        },
        'imagens': ['https://example.com/img1.jpg', 'https://example.com/img2.jpg'],
        'diferenciais': ['Piscina', 'Churrasqueira'],
        'corretor': {
          'nome': 'João Silva',
          'telefone': '(69) 99999-9999',
        },
      };

      final property = PropertyModel.fromJson(json);

      expect(property.id, 'test-id-123');
      expect(property.titulo, 'Casa em Centro');
      expect(property.tipo, 'Residencial');
      expect(property.subtipo, 'Casa');
      expect(property.disponibilidade, 'Venda');
      expect(property.status, 'Ativo');
      expect(property.bairro, 'Centro');
      expect(property.cidade, 'Ariquemes');
      expect(property.estado, 'RO');
      expect(property.preco, 350000.0);
      expect(property.areaTotal, 200.0);
      expect(property.areaConstruida, 180.0);
      expect(property.quartos, 3);
      expect(property.banheiros, 2);
      expect(property.suites, 1);
      expect(property.condicao, 'Novo');
      expect(property.mobiliado, false);
      expect(property.rua, 'Rua Teste');
      expect(property.numero, '123');
      expect(property.cep, '76800-100');
      expect(property.imagens, hasLength(2));
      expect(property.diferenciais, containsAll(['Piscina', 'Churrasqueira']));
      expect(property.nomeFantasiaCorretor, 'João Silva');
      expect(property.telefoneCorretor, '(69) 99999-9999');
    });

    test('deve parsear JSON de imóvel rural', () {
      final json = {
        'id': 'rural-123',
        'titulo': 'Fazenda em Zona Rural',
        'tipo': 'Rural',
        'subtipo': 'Fazenda',
        'disponibilidade': 'Venda',
        'status': 'Ativo',
        'bairro': 'Zona Rural',
        'cidade': 'Ariquemes',
        'estado': 'RO',
        'descricao': 'Fazenda grande com pastagem',
        'preco': 500000.0,
        'areaTotal': 5000.0,
        'rural': {
          'lote': 'Lote 1',
          'gleba': 'Gleba A',
          'mobiliado': false,
          'topografia': 'Plana',
          'recursosHidricos': ['Rio'],
          'atividadeDestinada': 'Pecuaria',
        },
        'imagens': [],
        'diferenciais': [],
      };

      final property = PropertyModel.fromJson(json);

      expect(property.tipo, 'Rural');
      expect(property.subtipo, 'Fazenda');
      expect(property.areaTotal, 5000.0);
    });

    test('deve lidar com valores nulos', () {
      final json = <String, dynamic>{
        'id': 'null-test',
        'titulo': 'Teste',
        'tipo': 'Terreno',
        'subtipo': 'Terreno',
        'disponibilidade': 'Venda',
        'status': 'Ativo',
        'bairro': 'Centro',
        'cidade': 'Ariquemes',
        'estado': 'RO',
        'descricao': 'Teste de nulos',
      };

      final property = PropertyModel.fromJson(json);

      expect(property.preco, isNull);
      expect(property.valorAluguel, isNull);
      expect(property.valorArrendamento, isNull);
      expect(property.thumbnail, isNull);
      expect(property.imagens, isEmpty);
      expect(property.quartos, isNull);
      expect(property.banheiros, isNull);
      expect(property.suites, isNull);
      expect(property.condicao, isNull);
      expect(property.mobiliado, false);
    });

    test('deve converter para JSON corretamente', () {
      final property = PropertyModel(
        id: 'test-id',
        titulo: 'Casa Teste',
        tipo: 'Residencial',
        subtipo: 'Casa',
        disponibilidade: 'Venda',
        status: 'Ativo',
        bairro: 'Centro',
        cidade: 'Ariquemes',
        estado: 'RO',
        descricao: 'Descrição',
        preco: 300000.0,
      );

      final json = property.toJson();

      expect(json['id'], 'test-id');
      expect(json['titulo'], 'Casa Teste');
      expect(json['tipo'], 'Residencial');
      expect(json['preco'], 300000.0);
    });
  });

  group('AppUser', () {
    test('deve parsear JSON de usuário', () {
      final json = {
        'id': 'user-123',
        'nome': 'João Silva',
        'email': 'joao.silva@teste.com',
        'telefone': '(69) 99999-9999',
        'creci': '123456',
        'status': 'ativo',
        'isAdmin': false,
      };

      final user = AppUser.fromJson(json);

      expect(user.id, 'user-123');
      expect(user.nome, 'João Silva');
      expect(user.email, 'joao.silva@teste.com');
      expect(user.isAdmin, false);
    });
  });

  group('LoginResponseModel', () {
    test('deve parsear resposta de login', () {
      final json = {
        'accessToken': 'jwt-access-token',
        'refreshToken': 'jwt-refresh-token',
        'corretor': {
          'id': 'user-123',
          'nome': 'João Silva',
          'email': 'joao@teste.com',
          'telefone': '69999999999',
          'creci': '123456',
          'status': 'ativo',
        },
      };

      final response = LoginResponseModel.fromJson(json);

      expect(response.accessToken, 'jwt-access-token');
      expect(response.refreshToken, 'jwt-refresh-token');
      expect(response.user.nome, 'João Silva');
    });
  });
}
