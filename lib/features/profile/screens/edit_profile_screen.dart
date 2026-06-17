import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../features/auth/auth_controller.dart';
import '../../../services/profile_api_service.dart';
import '../../../widgets/app_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _nomeFantasiaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _profileService = ProfileApiService();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).currentUser;
    _nomeFantasiaController.text = user?.nomeFantasia ?? '';
    _telefoneController.text = user?.telefone ?? '';
    _descricaoController.text = user?.descricao ?? '';
    _instagramController.text = user?.instagram ?? '';
    _facebookController.text = user?.facebook ?? '';
  }

  @override
  void dispose() {
    _nomeFantasiaController.dispose();
    _telefoneController.dispose();
    _descricaoController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _profileService.updateProfile(
        nomeFantasia: _nomeFantasiaController.text.trim(),
        telefone: _telefoneController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );
      await _profileService.updateSocials(
        instagram: _instagramController.text.trim(),
        facebook: _facebookController.text.trim(),
      );
      await ref.read(authControllerProvider).refreshProfile();
      if (mounted) showAppSnackBar(context, 'Perfil atualizado com sucesso.');
    } catch (error) {
      if (mounted) showAppSnackBar(context, error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    try {
      setState(() => _saving = true);
      await _profileService.updatePhoto(croppedPath: file.path);
      await ref.read(authControllerProvider).refreshProfile();
      if (mounted) showAppSnackBar(context, 'Foto atualizada com sucesso.');
    } catch (error) {
      if (mounted) showAppSnackBar(context, error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _saving ? null : _pickPhoto,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 28,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Alterar foto',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Informações pessoais'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomeFantasiaController,
                decoration: const InputDecoration(
                  labelText: 'Nome fantasia',
                  prefixIcon: Icon(Icons.store_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description_outlined, size: 20),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Redes sociais'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instagramController,
                decoration: const InputDecoration(
                  labelText: 'Instagram',
                  prefixIcon: Icon(Icons.camera_alt_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(
                  labelText: 'Facebook',
                  prefixIcon: Icon(Icons.facebook, size: 20),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
