import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client.dart';

class ClientFormPage extends StatefulWidget {
  final ClientService service;
  final Client? initial;

  const ClientFormPage({super.key, required this.service, this.initial});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cnpjCtrl;
  late TextEditingController _razaoCtrl;
  late TextEditingController _fantasiaCtrl;
  late TextEditingController _regimeCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telefoneCtrl;
  late TextEditingController _enderecoCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _cnpjCtrl = TextEditingController(text: widget.initial?.cnpj ?? '');
    _razaoCtrl = TextEditingController(text: widget.initial?.razaoSocial ?? '');
    _fantasiaCtrl = TextEditingController(
      text: widget.initial?.nomeFantasia ?? '',
    );
    _regimeCtrl = TextEditingController(
      text: widget.initial?.regimeTributario ?? '',
    );
    _emailCtrl = TextEditingController(text: widget.initial?.email ?? '');
    _telefoneCtrl = TextEditingController(text: widget.initial?.telefone ?? '');
    _enderecoCtrl = TextEditingController(text: widget.initial?.endereco ?? '');
  }

  @override
  void dispose() {
    _cnpjCtrl.dispose();
    _razaoCtrl.dispose();
    _fantasiaCtrl.dispose();
    _regimeCtrl.dispose();
    _emailCtrl.dispose();
    _telefoneCtrl.dispose();
    _enderecoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final client = Client(
      id: widget.initial?.id,
      cnpj: _cnpjCtrl.text.trim(),
      razaoSocial: _razaoCtrl.text.trim(),
      nomeFantasia: _fantasiaCtrl.text.trim(),
      regimeTributario: _regimeCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim(),
      endereco: _enderecoCtrl.text.trim(),
    );

    try {
      if (widget.initial == null) {
        await widget.service.createClient(client);
      } else {
        await widget.service.updateClient(client);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Editar Cliente' : 'Novo Cliente')),
      body: AbsorbPointer(
        absorbing: _saving,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _cnpjCtrl,
                  decoration: const InputDecoration(labelText: 'CNPJ'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o CNPJ';
                    if (v.replaceAll(RegExp(r'\D'), '').length != 14)
                      return 'CNPJ inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _razaoCtrl,
                  decoration: const InputDecoration(labelText: 'Razão Social'),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Informe a razão social'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fantasiaCtrl,
                  decoration: const InputDecoration(labelText: 'Nome Fantasia'),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Informe o nome fantasia'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _regimeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Regime Tributário',
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Informe o regime tributário'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o email';
                    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
                        ? null
                        : 'Email inválido';
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefoneCtrl,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe o telefone' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _enderecoCtrl,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe o endereço' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(editing ? 'Salvar alterações' : 'Criar Cliente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
