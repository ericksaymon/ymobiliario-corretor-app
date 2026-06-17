import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/app_models.dart';
import '../../../services/property_api_service.dart';
import '../../../widgets/app_widgets.dart';

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key, this.propertyId});

  final String? propertyId;

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PropertyApiService();
  final _picker = ImagePicker();
  bool _loading = false;
  bool _bootstrapping = true;

  final _descricaoController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController(text: 'Ariquemes');
  final _estadoController = TextEditingController(text: 'RO');
  final _cepController = TextEditingController();
  final _areaTotalController = TextEditingController();
  final _precoController = TextEditingController();
  final _valorAluguelController = TextEditingController();
  final _valorArrendamentoController = TextEditingController();
  final _quartosController = TextEditingController(text: '0');
  final _banheirosController = TextEditingController(text: '0');
  final _suitesController = TextEditingController(text: '0');
  final _areaConstruidaController = TextEditingController();
  final _loteController = TextEditingController();
  final _glebaController = TextEditingController();
  final _projetoController = TextEditingController();

  String _tipo = 'Residencial';
  String _subtipo = 'Casa';
  String _disponibilidade = 'Venda';
  final String _exclusividade = 'Compartilhado';
  String _condicao = 'Usado';
  bool _mobiliado = false;
  bool _aceitaFinanciamento = false;
  bool _aceitaVeiculo = false;
  bool _aceitaPermuta = false;
  int _thumbnailIndex = 0;
  List<String> _bairros = const [];
  Map<String, List<String>> _subtipos = const {};
  List<String> _diferenciaisDisponiveis = const [];
  final Set<String> _diferenciaisSelecionados = <String>{};
  final List<XFile> _newImages = <XFile>[];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _areaTotalController.dispose();
    _precoController.dispose();
    _valorAluguelController.dispose();
    _valorArrendamentoController.dispose();
    _quartosController.dispose();
    _banheirosController.dispose();
    _suitesController.dispose();
    _areaConstruidaController.dispose();
    _loteController.dispose();
    _glebaController.dispose();
    _projetoController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      final results = await Future.wait([
        _service.listBairros(),
        _service.listSubtipos(),
        _service.listDiferenciais(),
      ]);
      _bairros = results[0] as List<String>;
      _subtipos = results[1] as Map<String, List<String>>;
      _diferenciaisDisponiveis = results[2] as List<String>;
      _subtipo = _subtipos[_tipo]?.firstOrNull ?? 'Casa';

      if (widget.propertyId != null) {
        final property = await _service.getById(widget.propertyId!);
        _hydrate(property);
      }
    } catch (error) {
      if (mounted) {
        showAppSnackBar(context, error.toString(), error: true);
      }
    } finally {
      if (mounted) {
        setState(() => _bootstrapping = false);
      }
    }
  }

  void _hydrate(PropertyModel property) {
    _descricaoController.text = property.descricao;
    _ruaController.text = property.rua ?? '';
    _numeroController.text = property.numero ?? '';
    _bairroController.text = property.bairro;
    _cidadeController.text = property.cidade;
    _estadoController.text = property.estado;
    _cepController.text = property.cep ?? '';
    _areaTotalController.text = property.areaTotal?.toString() ?? '';
    _precoController.text = property.preco?.toString() ?? '';
    _valorAluguelController.text = property.valorAluguel?.toString() ?? '';
    _valorArrendamentoController.text =
        property.valorArrendamento?.toString() ?? '';
    _quartosController.text = (property.quartos ?? 0).toString();
    _banheirosController.text = (property.banheiros ?? 0).toString();
    _suitesController.text = (property.suites ?? 0).toString();
    _areaConstruidaController.text = property.areaConstruida?.toString() ?? '';
    _tipo = property.tipo;
    _subtipo = property.subtipo;
    _disponibilidade = property.disponibilidade;
    _condicao = property.condicao ?? 'Usado';
    _mobiliado = property.mobiliado ?? false;
    _diferenciaisSelecionados
      ..clear()
      ..addAll(property.diferenciais);
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isEmpty) {
      return;
    }
    setState(() {
      _newImages.addAll(images);
      if (_newImages.length == 1) {
        _thumbnailIndex = 0;
      }
    });
  }

  Map<String, dynamic> _buildPayload() {
    final payload = <String, dynamic>{
      'titulo': '${_subtipo.trim()} em ${_bairroController.text.trim()}',
      'descricao': _descricaoController.text.trim(),
      'tipo': _tipo,
      'subtipo': _subtipo,
      'disponibilidade': _disponibilidade,
      'exclusividade': _exclusividade,
      'rua': _ruaController.text.trim(),
      'numero': _numeroController.text.trim(),
      'bairro': _bairroController.text.trim(),
      'cidade': _cidadeController.text.trim(),
      'estado': _estadoController.text.trim(),
      'cep': _cepController.text.trim(),
      'areaTotal': double.tryParse(_areaTotalController.text.trim()) ?? 0,
      'preco': double.tryParse(_precoController.text.trim()),
      'valorAluguel': double.tryParse(_valorAluguelController.text.trim()),
      'valorArrendamento':
          double.tryParse(_valorArrendamentoController.text.trim()),
      'aptoFinanciamento': _aceitaFinanciamento,
      'aceitaVeiculo': _aceitaVeiculo,
      'aceitaPermuta': _aceitaPermuta,
      'diferenciais': _diferenciaisSelecionados.toList(),
      'thumbnailIndex': _thumbnailIndex,
    };

    if (_tipo == 'Residencial') {
      payload['residencial'] = {
        'condicao': _condicao,
        'quartos': int.tryParse(_quartosController.text) ?? 0,
        'banheiros': int.tryParse(_banheirosController.text) ?? 0,
        'numero_suites': int.tryParse(_suitesController.text) ?? 0,
        'areaConstruida':
            double.tryParse(_areaConstruidaController.text.trim()) ?? 0,
        'mobiliado': _mobiliado,
      };
    }

    if (_tipo == 'Comercial') {
      payload['comercial'] = {
        'condicao': _condicao,
        'mobiliado': _mobiliado,
      };
    }

    if (_tipo == 'Industrial') {
      payload['industrial'] = {
        'condicao': _condicao,
        'mobiliado': _mobiliado,
        'areaConstruida':
            double.tryParse(_areaConstruidaController.text.trim()) ?? 0,
      };
    }

    if (_tipo == 'Rural') {
      payload['rural'] = {
        'lote': _loteController.text.trim(),
        'gleba': _glebaController.text.trim(),
        'projetoAssentamento': _projetoController.text.trim(),
        'mobiliado': _mobiliado,
        'documentacao': <String>[],
        'benfeitorias': <String>[],
        'topografia': 'Plana',
        'recursosHidricos': ['Rio'],
        'atividadeDestinada': 'Mista',
      };
    }

    return payload;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (widget.propertyId == null && _newImages.length < 3) {
      showAppSnackBar(context, 'Adicione pelo menos 3 imagens.', error: true);
      return;
    }
    setState(() => _loading = true);
    try {
      final payload = _buildPayload();
      if (widget.propertyId == null) {
        await _service.create(
          data: payload,
          imagePaths: _newImages.map((image) => image.path).toList(),
          thumbnailIndex: _thumbnailIndex,
        );
      } else {
        await _service.update(
          id: widget.propertyId!,
          data: payload,
          newImagePaths: _newImages.map((image) => image.path).toList(),
        );
      }
      if (mounted) {
        showAppSnackBar(context, 'Imóvel salvo com sucesso.');
        context.go('/properties');
      }
    } catch (error) {
      if (mounted) {
        showAppSnackBar(context, error.toString(), error: true);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bootstrapping) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final subtiposAtuais = _subtipos[_tipo] ?? const ['Casa'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propertyId == null
            ? 'Cadastrar imóvel'
            : 'Editar imóvel'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: _subtipos.keys
                    .map(
                      (tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _tipo = value;
                    _subtipo = (_subtipos[_tipo]?.firstOrNull ?? _subtipo);
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: subtiposAtuais.contains(_subtipo)
                    ? _subtipo
                    : subtiposAtuais.first,
                decoration: const InputDecoration(labelText: 'Subtipo'),
                items: subtiposAtuais
                    .map(
                      (subtipo) => DropdownMenuItem(
                        value: subtipo,
                        child: Text(subtipo),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _subtipo = value ?? _subtipo),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _disponibilidade,
                decoration: const InputDecoration(labelText: 'Disponibilidade'),
                items: const [
                  DropdownMenuItem(value: 'Venda', child: Text('Venda')),
                  DropdownMenuItem(value: 'Aluguel', child: Text('Aluguel')),
                  DropdownMenuItem(
                    value: 'Arrendamento',
                    child: Text('Arrendamento'),
                  ),
                  DropdownMenuItem(value: 'Ambos', child: Text('Ambos')),
                ],
                onChanged: (value) =>
                    setState(() => _disponibilidade = value ?? _disponibilidade),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.length < 20
                    ? 'A descrição precisa ter pelo menos 20 caracteres'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ruaController,
                decoration: const InputDecoration(labelText: 'Rua'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a rua' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Número'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _bairros.contains(_bairroController.text)
                    ? _bairroController.text
                    : null,
                decoration: const InputDecoration(labelText: 'Bairro'),
                items: _bairros
                    .map(
                      (bairro) => DropdownMenuItem(
                        value: bairro,
                        child: Text(bairro),
                      ),
                    )
                    .toList(),
                onChanged: (value) => _bairroController.text = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Selecione o bairro' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaTotalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Área total'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a área total' : null,
              ),
              const SizedBox(height: 12),
              if (_disponibilidade == 'Venda' ||
                  _disponibilidade == 'Ambos') ...[
                TextFormField(
                  controller: _precoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Preço de venda'),
                ),
                const SizedBox(height: 12),
              ],
              if (_disponibilidade == 'Aluguel' ||
                  (_disponibilidade == 'Ambos' && _tipo != 'Rural')) ...[
                TextFormField(
                  controller: _valorAluguelController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valor do aluguel'),
                ),
                const SizedBox(height: 12),
              ],
              if (_disponibilidade == 'Arrendamento' ||
                  (_disponibilidade == 'Ambos' && _tipo == 'Rural')) ...[
                TextFormField(
                  controller: _valorArrendamentoController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Valor do arrendamento'),
                ),
                const SizedBox(height: 12),
              ],
              if (_tipo == 'Residencial' ||
                  _tipo == 'Comercial' ||
                  _tipo == 'Industrial') ...[
                DropdownButtonFormField<String>(
                  initialValue: _condicao,
                  decoration: const InputDecoration(labelText: 'Condição'),
                  items: const [
                    DropdownMenuItem(value: 'Usado', child: Text('Usado')),
                    DropdownMenuItem(value: 'Novo', child: Text('Novo')),
                    DropdownMenuItem(
                      value: 'Na planta',
                      child: Text('Na planta'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _condicao = value ?? _condicao),
                ),
                const SizedBox(height: 12),
              ],
              if (_tipo == 'Residencial') ...[
                TextFormField(
                  controller: _quartosController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quartos'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _banheirosController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Banheiros'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _suitesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Suítes'),
                ),
                const SizedBox(height: 12),
              ],
              if (_tipo == 'Residencial' || _tipo == 'Industrial') ...[
                TextFormField(
                  controller: _areaConstruidaController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Área construída'),
                ),
                const SizedBox(height: 12),
              ],
              if (_tipo == 'Rural') ...[
                TextFormField(
                  controller: _loteController,
                  decoration: const InputDecoration(labelText: 'Lote'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _glebaController,
                  decoration: const InputDecoration(labelText: 'Gleba'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _projetoController,
                  decoration:
                      const InputDecoration(labelText: 'Projeto de assentamento'),
                ),
                const SizedBox(height: 12),
              ],
              SwitchListTile(
                value: _mobiliado,
                onChanged: (value) => setState(() => _mobiliado = value),
                title: const Text('Mobiliado'),
              ),
              SwitchListTile(
                value: _aceitaFinanciamento,
                onChanged: (value) =>
                    setState(() => _aceitaFinanciamento = value),
                title: const Text('Aceita financiamento'),
              ),
              SwitchListTile(
                value: _aceitaVeiculo,
                onChanged: (value) => setState(() => _aceitaVeiculo = value),
                title: const Text('Aceita veículo'),
              ),
              SwitchListTile(
                value: _aceitaPermuta,
                onChanged: (value) => setState(() => _aceitaPermuta = value),
                title: const Text('Aceita permuta'),
              ),
              const SizedBox(height: 16),
              Text(
                'Diferenciais',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _diferenciaisDisponiveis.map((item) {
                  final selected = _diferenciaisSelecionados.contains(item);
                  return FilterChip(
                    label: Text(item),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _diferenciaisSelecionados.add(item);
                        } else {
                          _diferenciaisSelecionados.remove(item);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  _newImages.isEmpty
                      ? 'Adicionar imagens'
                      : '${_newImages.length} novas imagens',
                ),
              ),
              if (_newImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _thumbnailIndex,
                  decoration: const InputDecoration(labelText: 'Imagem de capa'),
                  items: List.generate(
                    _newImages.length,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text('Imagem ${index + 1}'),
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => _thumbnailIndex = value ?? 0),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: Text(
                  _loading
                      ? 'Salvando...'
                      : widget.propertyId == null
                          ? 'Cadastrar imóvel'
                          : 'Salvar alterações',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
