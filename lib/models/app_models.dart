class AppUser {
  AppUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.creci,
    required this.status,
    this.nomeFantasia,
    this.descricao,
    this.instagram,
    this.facebook,
    this.fotoPerfil,
    this.isAdmin = false,
  });

  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String creci;
  final String status;
  final String? nomeFantasia;
  final String? descricao;
  final String? instagram;
  final String? facebook;
  final String? fotoPerfil;
  final bool isAdmin;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? '').toString(),
      nome: (json['nome'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      telefone: (json['telefone'] ?? '').toString(),
      creci: (json['creci'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      nomeFantasia: json['nomeFantasia']?.toString(),
      descricao: json['descricao']?.toString(),
      instagram: json['instagram']?.toString(),
      facebook: json['facebook']?.toString(),
      fotoPerfil: json['fotoPerfil']?.toString(),
      isAdmin: json['isAdmin'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'creci': creci,
        'status': status,
        'nomeFantasia': nomeFantasia,
        'descricao': descricao,
        'instagram': instagram,
        'facebook': facebook,
        'fotoPerfil': fotoPerfil,
        'isAdmin': isAdmin,
      };
}

class LoginResponseModel {
  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AppUser user;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
      user: AppUser.fromJson(json['corretor'] as Map<String, dynamic>),
    );
  }
}

class PropertyModel {
  PropertyModel({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.subtipo,
    required this.disponibilidade,
    required this.status,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.descricao,
    this.preco,
    this.valorAluguel,
    this.valorArrendamento,
    this.thumbnail,
    this.imagens = const <String>[],
    this.visualizacoes = 0,
    this.totalTentativasContato = 0,
    this.areaTotal,
    this.areaConstruida,
    this.quartos,
    this.banheiros,
    this.suites,
    this.condicao,
    this.mobiliado,
    this.rua,
    this.numero,
    this.cep,
    this.nomeFantasiaCorretor,
    this.telefoneCorretor,
    this.fotoPerfilCorretor,
    this.diferenciais = const <String>[],
  });

  final String id;
  final String titulo;
  final String tipo;
  final String subtipo;
  final String disponibilidade;
  final String status;
  final String bairro;
  final String cidade;
  final String estado;
  final String descricao;
  final double? preco;
  final double? valorAluguel;
  final double? valorArrendamento;
  final String? thumbnail;
  final List<String> imagens;
  final int visualizacoes;
  final int totalTentativasContato;
  final double? areaTotal;
  final double? areaConstruida;
  final int? quartos;
  final int? banheiros;
  final int? suites;
  final String? condicao;
  final bool? mobiliado;
  final String? rua;
  final String? numero;
  final String? cep;
  final String? nomeFantasiaCorretor;
  final String? telefoneCorretor;
  final String? fotoPerfilCorretor;
  final List<String> diferenciais;

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final residencial = json['residencial'] as Map<String, dynamic>?;
    final comercial = json['comercial'] as Map<String, dynamic>?;
    final industrial = json['industrial'] as Map<String, dynamic>?;
    final rural = json['rural'] as Map<String, dynamic>?;
    final corretor = json['corretor'] as Map<String, dynamic>?;
    final imagensJson = json['imagens'];

    List<String> imagens = [];
    if (imagensJson is List) {
      imagens = imagensJson.map((item) {
        if (item is Map<String, dynamic>) {
          return (item['url'] ?? '').toString();
        }
        return item.toString();
      }).where((item) => item.isNotEmpty).toList();
    }

    return PropertyModel(
      id: (json['id'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      tipo: (json['tipo'] ?? '').toString(),
      subtipo: (json['subtipo'] ?? '').toString(),
      disponibilidade: (json['disponibilidade'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      bairro: (json['bairro'] ?? '').toString(),
      cidade: (json['cidade'] ?? '').toString(),
      estado: (json['estado'] ?? '').toString(),
      descricao: (json['descricao'] ?? '').toString(),
      preco: _toDouble(json['preco']),
      valorAluguel: _toDouble(json['valorAluguel']),
      valorArrendamento: _toDouble(json['valorArrendamento']),
      thumbnail: json['thumbnail']?.toString(),
      imagens: imagens,
      visualizacoes: _toInt(json['visualizacoes']) ?? 0,
      totalTentativasContato: _toInt(json['totalTentativasContato']) ?? 0,
      areaTotal: _toDouble(json['areaTotal']),
      areaConstruida: _toDouble(
        residencial?['areaConstruida'] ??
            industrial?['areaConstruida'] ??
            rural?['areaConstruida'],
      ),
      quartos: _toInt(residencial?['quartos']),
      banheiros: _toInt(residencial?['banheiros']),
      suites: _toInt(residencial?['numero_suites']),
      condicao: residencial?['condicao']?.toString() ??
          comercial?['condicao']?.toString() ??
          industrial?['condicao']?.toString(),
      mobiliado: (residencial?['mobiliado'] ??
              comercial?['mobiliado'] ??
              industrial?['mobiliado'] ??
              rural?['mobiliado']) ==
          true,
      rua: json['rua']?.toString(),
      numero: json['numero']?.toString(),
      cep: json['cep']?.toString(),
      nomeFantasiaCorretor:
          corretor?['nomeFantasia']?.toString() ?? corretor?['nome']?.toString(),
      telefoneCorretor: corretor?['telefone']?.toString(),
      fotoPerfilCorretor: corretor?['fotoPerfil']?.toString(),
      diferenciais: (json['diferenciais'] is List)
          ? (json['diferenciais'] as List)
              .map((item) => item.toString())
              .toList()
          : const <String>[],
    );
  }
}
