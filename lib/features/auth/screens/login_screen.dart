import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../widgets/app_widgets.dart';
import '../auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authControllerProvider).login(
            email: _emailController.text.trim(),
            senha: _passwordController.text,
          );
      if (mounted) context.go('/dashboard');
    } catch (error) {
      if (mounted) showAppSnackBar(context, error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return AuthLayout(
      title: 'Entrar como corretor',
      subtitle: 'Acesse seu painel, seus imóveis e seus contatos.',
      showBackButton: false,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SurfacePanel(
              radius: 20,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primaryLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Acesse sua carteira de imóveis, contatos e performance em um painel unificado.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Informe o email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Informe a senha' : null,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/forgot-password'),
                child: const Text('Esqueci minha senha'),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: auth.loading ? null : _submit,
              child: auth.loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Entrar'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ou',
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => context.go('/register'),
              icon: const Icon(Icons.person_add_outlined, size: 20),
              label: const Text('Criar conta'),
            ),
            if (auth.lastError != null) ...[
              const SizedBox(height: 16),
              SurfacePanel(
                radius: 14,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        auth.lastError!,
                        style: const TextStyle(color: AppColors.danger, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
