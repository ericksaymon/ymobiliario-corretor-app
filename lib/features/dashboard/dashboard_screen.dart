import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/dashboard/widgets/dashboard_components.dart';
import '../../services/property_api_service.dart';
import '../../widgets/app_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.currentUser;
    final propertyService = PropertyApiService();

    return FutureBuilder(
      future: propertyService.myProperties(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        final totalViews = items.fold<int>(
          0,
          (sum, item) => sum + item.visualizacoes,
        );
        final totalContacts = items.fold<int>(
          0,
          (sum, item) => sum + item.totalTentativasContato,
        );
        final activeCount = items.where((e) => e.status == 'Ativo').length;

        return AppShell(
          title: 'Painel do corretor',
          currentIndex: 0,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DashboardHeroCard(
                greeting:
                    'Olá, ${user?.nomeFantasia?.isNotEmpty == true ? user!.nomeFantasia! : user?.nome ?? 'Corretor'}',
                subtitle:
                    '${user?.creci ?? '-'} • ${user?.status ?? '-'}\nOrganize seus anúncios e acompanhe o interesse dos clientes.',
                actions: [
                  DashboardQuickAction(
                    icon: Icons.add_home_outlined,
                    label: 'Cadastrar',
                    onTap: () => context.go('/properties/new'),
                  ),
                  DashboardQuickAction(
                    icon: Icons.home_work_outlined,
                    label: 'Imóveis',
                    onTap: () => context.go('/properties'),
                  ),
                  DashboardQuickAction(
                    icon: Icons.edit_outlined,
                    label: 'Perfil',
                    onTap: () => context.go('/profile/edit'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DashboardStatsSection(
                totalProperties: items.length,
                totalViews: totalViews,
                totalContacts: totalContacts,
                activeCount: activeCount,
              ),
            ],
          ),
        );
      },
    );
  }
}
