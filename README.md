# ymobiliario_corretor_app

App mobile Flutter para corretores de imóveis — marketplace imobiliário.

## Pré-requisitos

- Flutter SDK ^3.11.5
- Backend rodando em `http://localhost:3001` (ou `http://10.0.2.2:3001` no emulador Android)

## Usuários de teste (DB de dev)

| Email              | Senha      | Perfil   | CRECI  |
|--------------------|------------|----------|--------|
| `joao.silva@teste.com` | `Senha@123` | Corretor | 123456 |
| `admin@teste.com`      | `Senha@123` | Admin    | 111111 |

> **Nota:** O cadastro de imóveis requer perfil **Corretor** ativo com plano válido.

## Configuração da API

A URL base da API é definida em `lib/core/config.dart`:

| Ambiente          | URL                         |
|-------------------|-----------------------------|
| Android Emulator  | `http://10.0.2.2:3001`      |
| iOS Simulator     | `http://localhost:3001`      |
| Device físico     | Alterar para IP da máquina  |

## Rodar o app

```bash
flutter pub get
flutter run
```

## Testes

```bash
# Testes unitários
flutter test

# Testes de integração (requer backend rodando)
flutter test integration_test/
```

## Estrutura do projeto

```
lib/
├── core/           # Config, API client, session manager
├── features/       # Módulos organizados por feature
│   ├── auth/       # Login, registro, recuperação de senha
│   └── properties/ # Cadastro, listagem, edição de imóveis
├── models/         # Data models (AppUser, PropertyModel, etc.)
├── services/       # Serviços de API (Auth, Property)
└── widgets/        # Widgets reutilizáveis
```

## Regras de negócio (cadastro de imóvel)

- **Mínimo 3 imagens** (JPG/PNG/WEBP, máx. 20)
- **CEP válido** — apenas Rondônia (76800-76999)
- **Descrição** — mínimo 20 caracteres
- **Preço** obrigatório para Venda; **valorAluguel** para Aluguel; **valorArrendamento** para Arrendamento (rural)
- **Tipos:** Residencial, Rural, Terreno, Comercial, Industrial
- **Subtipos por tipo:**
  - Residencial: Casa, Apartamento, Cobertura, Kitnet, Loft, Sobrado
  - Rural: Chacara, Sitio, Fazenda
  - Terreno: Terreno
  - Comercial: Sala Comercial, Predio Comercial
  - Industrial: Galpao
