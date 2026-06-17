import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../widgets/app_widgets.dart';

class DashboardHeroCard extends StatelessWidget {
  const DashboardHeroCard({
    super.key,
    required this.greeting,
    required this.subtitle,
    required this.actions,
  });

  final String greeting;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB26B), AppColors.primary, Color(0xFFCB4D00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.26),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Icon(
              Icons.real_estate_agent_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            greeting,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children:
                actions
                    .expand(
                      (action) => [
                        Expanded(child: action),
                        const SizedBox(width: 10),
                      ],
                    )
                    .toList()
                  ..removeLast(),
          ),
        ],
      ),
    );
  }
}

class DashboardQuickAction extends StatelessWidget {
  const DashboardQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardStatsSection extends StatelessWidget {
  const DashboardStatsSection({
    super.key,
    required this.totalProperties,
    required this.totalViews,
    required this.totalContacts,
    required this.activeCount,
  });

  final int totalProperties;
  final int totalViews;
  final int totalContacts;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Resumo da operação',
          subtitle: 'Acompanhe o desempenho dos seus anúncios.',
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.02,
          children: [
            InfoCard(
              title: 'Imóveis cadastrados',
              value: '$totalProperties',
              icon: Icons.home_work_outlined,
            ),
            InfoCard(
              title: 'Total de visitas',
              value: '$totalViews',
              icon: Icons.visibility_outlined,
              color: AppColors.success,
            ),
            InfoCard(
              title: 'Tentativas de contato',
              value: '$totalContacts',
              icon: Icons.call_outlined,
              color: AppColors.warning,
            ),
            InfoCard(
              title: 'Imóveis ativos',
              value: '$activeCount',
              icon: Icons.check_circle_outline,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
