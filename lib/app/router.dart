import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/verify_reset_code_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/profile/screens/change_password_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/properties/screens/my_properties_screen.dart';
import '../features/properties/screens/property_detail_screen.dart';
import '../features/properties/screens/property_form_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authController = ref.watch(authControllerProvider);

  const authRoutes = <String>{
    '/',
    '/login',
    '/register',
    '/forgot-password',
    '/verify-code',
    '/reset-password',
  };

  bool isProtected(String location) {
    return location.startsWith('/dashboard') ||
        location.startsWith('/properties') ||
        location.startsWith('/profile');
  }

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authController,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final signedIn = authController.isAuthenticated;
      final initialized = authController.initialized;

      if (!initialized) {
        return location == '/' ? null : '/';
      }

      if (!signedIn && location == '/') {
        return '/login';
      }

      if (!signedIn && isProtected(location)) {
        return '/login';
      }

      if (signedIn && authRoutes.contains(location)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-code',
        builder: (context, state) => VerifyResetCodeScreen(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordScreen(
          email: state.uri.queryParameters['email'] ?? '',
          code: state.uri.queryParameters['code'] ?? '',
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/properties',
        builder: (context, state) => const MyPropertiesScreen(),
      ),
      GoRoute(
        path: '/properties/new',
        builder: (context, state) => const PropertyFormScreen(),
      ),
      GoRoute(
        path: '/properties/:id',
        builder: (context, state) => PropertyDetailScreen(
          propertyId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/properties/:id/edit',
        builder: (context, state) => PropertyFormScreen(
          propertyId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
    ],
  );
});
