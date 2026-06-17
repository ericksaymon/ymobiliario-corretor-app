import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../features/auth/auth_controller.dart';
import '../../../widgets/app_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.currentUser;

    return AppShell(
      title: 'Meu perfil',
      currentIndex: 2,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surfaceElevated,
                      backgroundImage: user?.fotoPerfil != null &&
                              user!.fotoPerfil!.isNotEmpty
                          ? CachedNetworkImageProvider(user.fotoPerfil!)
                          : null,
                      child: user?.fotoPerfil == null || user!.fotoPerfil!.isEmpty
                          ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user?.nome ?? '-',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CRECI: ${user?.creci ?? '-'}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '-',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ProfileOption(
            icon: Icons.edit_outlined,
            title: 'Editar perfil',
            subtitle: 'Telefone, descrição e redes sociais',
            onTap: () => context.go('/profile/edit'),
          ),
          const SizedBox(height: 10),
          _ProfileOption(
            icon: Icons.lock_outline,
            title: 'Alterar senha',
            onTap: () => context.go('/profile/password'),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authControllerProvider).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, size: 20),
            label: const Text('Sair da conta'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 22),
          ],
        ),
      ),
    );
  }
}
