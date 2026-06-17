import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/session_manager.dart';
import '../../models/app_models.dart';
import '../../services/auth_api_service.dart';
import '../../services/profile_api_service.dart';

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController(
    authApiService: AuthApiService(),
    profileApiService: ProfileApiService(),
  );
});

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthApiService authApiService,
    required ProfileApiService profileApiService,
  })  : _authApiService = authApiService,
        _profileApiService = profileApiService {
    initialize();
  }

  final AuthApiService _authApiService;
  final ProfileApiService _profileApiService;

  bool initialized = false;
  bool loading = false;
  AppUser? currentUser;
  String? lastError;

  bool get isAuthenticated => currentUser != null;

  Future<void> initialize() async {
    try {
      await SessionManager.instance.load();
      if (SessionManager.instance.accessToken != null &&
          SessionManager.instance.refreshToken != null) {
        currentUser = await _profileApiService.me();
        await SessionManager.instance.updateUser(currentUser!);
      }
    } catch (_) {
      await SessionManager.instance.clear();
      currentUser = null;
    } finally {
      initialized = true;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String senha,
  }) async {
    loading = true;
    lastError = null;
    notifyListeners();

    try {
      final result = await _authApiService.login(email: email, senha: senha);
      currentUser = result.user;
      await SessionManager.instance.saveSession(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        user: result.user,
      );
    } catch (error) {
      lastError = _normalizeError(error);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SessionManager.instance.clear();
    currentUser = null;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    currentUser = await _profileApiService.me();
    await SessionManager.instance.updateUser(currentUser!);
    notifyListeners();
  }

  Future<void> register({
    required Map<String, dynamic> dados,
    required String fotoFrente,
    required String fotoVerso,
  }) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      await _authApiService.register(
        dados: dados,
        fotoCreciFrentePath: fotoFrente,
        fotoCreciVersoPath: fotoVerso,
      );
    } catch (error) {
      lastError = _normalizeError(error);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> sendResetCode(String email) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      await _authApiService.sendResetCode(email);
    } catch (error) {
      lastError = _normalizeError(error);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      await _authApiService.verifyResetCode(email: email, code: code);
    } catch (error) {
      lastError = _normalizeError(error);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String novaSenha,
  }) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      await _authApiService.resetPassword(
        email: email,
        code: code,
        novaSenha: novaSenha,
      );
    } catch (error) {
      lastError = _normalizeError(error);
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String _normalizeError(Object error) {
    final text = error.toString();
    return text.replaceFirst('Exception: ', '');
  }
}
