import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../widgets/app_widgets.dart';
import '../auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _nomeController = TextEditingController();
  final _nomeFantasiaController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _creciController = TextEditingController();
  final _senhaController = TextEditingController();
  final _dataController = TextEditingController();

  XFile? _fotoFrente;
  XFile? _fotoVerso;

  @override
  void dispose() {
    _nomeController.dispose();
    _nomeFantasiaController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _creciController.dispose();
    _senhaController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool frente) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      if (frente) {
        _fotoFrente = image;
      } else {
        _fotoVerso = image;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fotoFrente == null || _fotoVerso == null) {
      showAppSnackBar(context, 'Adicione a frente e o verso do CRECI.', error: true);
      return;
    }

    try {
      await ref.read(authControllerProvider).register(
            dados: {
              'nomeCompleto': _nomeController.text.trim(),
              'nomeFantasia': _nomeFantasiaController.text.trim(),
              'email': _emailController.text.trim(),
              'telefone': _telefoneController.text.trim(),
              'creci': _creciController.text.trim(),
              'senha': _senhaController.text,
              'dataNascimento': _dataController.text.trim(),
            },
            fotoFrente: _fotoFrente!.path,
            fotoVerso: _fotoVerso!.path,
          );
      if (mounted) {
        showAppSnackBar(context, 'Cadastro enviado com sucesso. Aguarde a aprovação da conta.');
        context.go('/login');
      }
    } catch (error) {
      if (mounted) showAppSnackBar(context, error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return AuthLayout(
      title: 'Criar conta',
      subtitle: 'Cadastre seus dados para operar seus imóveis pelo app.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Informe o nome completo' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _nomeFantasiaController,
              decoration: const InputDecoration(
                labelText: 'Nome fantasia',
                prefixIcon: Icon(Icons.store_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, size: 20),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || v.isEmpty ? 'Informe o email' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Informe o telefone' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _creciController,
              decoration: const InputDecoration(
                labelText: 'CRECI',
                prefixIcon: Icon(Icons.badge_outlined, size: 20),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Informe o CRECI' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _dataController,
              decoration: const InputDecoration(
                labelText: 'Data de nascimento',
                hintText: 'YYYY-MM-DD',
                prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Informe a data de nascimento' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock_outline, size: 20),
              ),
              validator: (v) => v == null || v.length < 8
                  ? 'A senha precisa ter pelo menos 8 caracteres'
                  : null,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documento CRECI',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Anexe a foto da frente e do verso',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _ImagePickerButton(
                        label: _fotoFrente == null ? 'Frente' : 'Frente ok',
                        icon: Icons.badge_outlined,
                        picked: _fotoFrente != null,
                        onTap: () => _pickImage(true),
                      ),
                      _ImagePickerButton(
                        label: _fotoVerso == null ? 'Verso' : 'Verso ok',
                        icon: Icons.badge_outlined,
                        picked: _fotoVerso != null,
                        onTap: () => _pickImage(false),
                      ),
                    ],
                  ),
                ],
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
                  : const Text('Enviar cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerButton extends StatelessWidget {
  const _ImagePickerButton({
    required this.label,
    required this.icon,
    required this.picked,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        picked ? Icons.check_circle_outline : icon,
        size: 18,
        color: picked ? AppColors.success : null,
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: picked ? AppColors.success : null,
        side: picked ? const BorderSide(color: AppColors.success) : null,
      ),
    );
  }
}
