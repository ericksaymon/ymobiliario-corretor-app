import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme.dart';
import '../../../services/property_api_service.dart';
import '../../../widgets/app_widgets.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context) {
    final service = PropertyApiService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do imóvel'),
        actions: [
          IconButton(
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(
                  text: 'Veja este imóvel: http://localhost:3001/imovel/$propertyId',
                ),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: FutureBuilder(
        future: service.getById(propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final property = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (property.thumbnail != null && property.thumbnail!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: property.thumbnail!,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 240,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFF1E8), Color(0xFFFFE0CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.home_work_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                property.titulo.isNotEmpty ? property.titulo : property.subtipo,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currencyLabel(property),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.muted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${property.rua ?? '-'}, ${property.numero ?? '-'}'),
                        Text(
                          '${property.bairro} - ${property.cidade}/${property.estado}',
                          style: TextStyle(color: AppColors.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(property.descricao),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _DetailChip(label: property.status),
                  _DetailChip(label: property.disponibilidade),
                  if (property.areaTotal != null)
                    _DetailChip(label: '${property.areaTotal} m²', icon: Icons.square_foot),
                  if (property.quartos != null)
                    _DetailChip(label: '${property.quartos} quartos', icon: Icons.bed_outlined),
                  if (property.banheiros != null)
                    _DetailChip(label: '${property.banheiros} banheiros', icon: Icons.bathtub_outlined),
                ],
              ),
              const SizedBox(height: 24),
              if (property.telefoneCorretor != null &&
                  property.telefoneCorretor!.isNotEmpty) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    await launchUrl(Uri.parse('tel:${property.telefoneCorretor}'));
                  },
                  icon: const Icon(Icons.phone_outlined),
                  label: const Text('Ligar para o corretor'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final number = property.telefoneCorretor!.replaceAll(RegExp(r'[^0-9]'), '');
                    await launchUrl(
                      Uri.parse('https://wa.me/55$number'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Abrir WhatsApp'),
                ),
              ],
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.go('/properties/$propertyId/edit'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar imóvel'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
