import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/app_widgets.dart';
import '../auth_controller.dart';

class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  const VerifyResetCodeScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<VerifyResetCodeScreen> createState() =>
      _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState
    extends ConsumerState<VerifyResetCodeScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await ref.read(authControllerProvider).verifyResetCode(
            email: widget.email,
            code: _codeController.text.trim(),
          );
      if (mounted) {
        context.go(
          '/reset-password?email=${Uri.encodeComponent(widget.email)}&code=${Uri.encodeComponent(_codeController.text.trim())}',
        );
      }
    } catch (error) {
      if (mounted) showAppSnackBar(context, error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return AuthLayout(
      title: 'Verificar código',
      subtitle: 'Digite o código de 6 dígitos enviado para ${widget.email}.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              labelText: 'Código',
              prefixIcon: Icon(Icons.pin_outlined, size: 20),
              hintText: '000000',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: auth.loading ? null : _submit,
            child: auth.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Validar código'),
          ),
        ],
      ),
    );
  }
}
