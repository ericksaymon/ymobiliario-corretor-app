import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../models/app_models.dart';
import '../../../services/property_api_service.dart';
import '../../../widgets/app_widgets.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  final _service = PropertyApiService();
  String _selectedStatus = 'Todos';
  late Future<List<PropertyModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.myProperties();
  }

  void _reload() {
    setState(() {
      _future = _service.myProperties(
        status: _selectedStatus == 'Todos' ? null : _selectedStatus,
      );
    });
  }

  Future<void> _delete(String id) async {
    await _service.delete(id);
    _reload();
  }

  Future<void> _changeStatus(String id, String status) async {
    await _service.changeStatus(id, status);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    const statuses = [
      'Todos',
      'Ativo',
      'Inativo',
      'Alugado',
      'Reservado',
      'AguardandoAprovacao',
      'Rejeitado',
      'ProcessandoImagens',
    ];

    return AppShell(
      title: 'Meus imóveis',
      currentIndex: 1,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/properties/new'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo imóvel'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Filtrar por status',
                prefixIcon: Icon(Icons.filter_list_outlined, size: 20),
              ),
              items: statuses
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                _selectedStatus = value ?? 'Todos';
                _reload();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PropertyModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_work_outlined, size: 56, color: AppColors.muted.withValues(alpha: 0.4)),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum imóvel encontrado',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cadastre seu primeiro imóvel',
                          style: TextStyle(color: AppColors.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final property = items[index];
                      return Column(
                        children: [
                          PropertyCard(
                            property: property,
                            onTap: () => context.go('/properties/${property.id}'),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => context.go('/properties/${property.id}/edit'),
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  label: const Text('Editar'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'delete') {
                                    await _delete(property.id);
                                    return;
                                  }
                                  await _changeStatus(property.id, value);
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'Ativo', child: Text('Marcar como ativo')),
                                  PopupMenuItem(value: 'Inativo', child: Text('Marcar como inativo')),
                                  PopupMenuItem(value: 'Alugado', child: Text('Marcar como alugado')),
                                  PopupMenuItem(value: 'Reservado', child: Text('Marcar como reservado')),
                                  PopupMenuDivider(),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Excluir', style: TextStyle(color: AppColors.danger)),
                                  ),
                                ],
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: const Icon(Icons.more_vert, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
