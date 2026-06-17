import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme.dart';
import '../../../widgets/app_widgets.dart';

class PropertyFormSectionCard extends StatelessWidget {
  const PropertyFormSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class PropertyFormHero extends StatelessWidget {
  const PropertyFormHero({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE4CC), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyFeatureToggle extends StatelessWidget {
  const PropertyFeatureToggle({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class PropertyImagesPanel extends StatelessWidget {
  const PropertyImagesPanel({
    super.key,
    required this.images,
    required this.thumbnailIndex,
    required this.onPickImages,
    required this.onThumbnailChanged,
  });

  final List<XFile> images;
  final int thumbnailIndex;
  final VoidCallback onPickImages;
  final ValueChanged<int?> onThumbnailChanged;

  @override
  Widget build(BuildContext context) {
    return PropertyFormSectionCard(
      title: 'Imagens do anúncio',
      subtitle: 'Adicione pelo menos 3 fotos e escolha a capa principal.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            onPressed: onPickImages,
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(
              images.isEmpty
                  ? 'Adicionar imagens'
                  : '${images.length} imagens selecionadas',
            ),
          ),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                images.length,
                (index) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: index == thumbnailIndex
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: index == thumbnailIndex
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    index == thumbnailIndex
                        ? 'Imagem ${index + 1} • Capa'
                        : 'Imagem ${index + 1}',
                    style: TextStyle(
                      color: index == thumbnailIndex
                          ? AppColors.primary
                          : AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              initialValue: thumbnailIndex,
              decoration: const InputDecoration(labelText: 'Imagem de capa'),
              items: List.generate(
                images.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text('Imagem ${index + 1}'),
                ),
              ),
              onChanged: onThumbnailChanged,
            ),
          ],
        ],
      ),
    );
  }
}
