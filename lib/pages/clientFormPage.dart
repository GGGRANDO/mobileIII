import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client.dart';

class ClientFormPage extends StatefulWidget {
  final ClientService service;
  final Client? initial; // null => criar; não-null => editar

  const ClientFormPage({super.key, required this.service, this.initial});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _avatar;
  bool _active = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name   = TextEditingController(text: widget.initial?.name ?? '');
    _email  = TextEditingController(text: widget.initial?.email ?? '');
    _avatar = TextEditingController(text: widget.initial?.avatar ?? '');
    _active = widget.initial?.active ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _avatar.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final model = Client(
        id: widget.initial?.id,
        name: _name.text.trim(),
        email: _email.text.trim(),
        avatar: _avatar.text.trim(),
        active: _active,
      );

      if (widget.initial == null) {
        await widget.service.createClient(model);
      } else {
        await widget.service.updateClient(model);
      }

      if (mounted) Navigator.of(context).pop(true); // sinaliza refresh
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (widget.initial?.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover cliente'),
        content: const Text('Tem certeza que deseja remover este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _saving = true);
    try {
      await widget.service.deleteClient(widget.initial!.id!);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar Cliente' : 'Novo Cliente'),
        actions: [
          if (editing)
            IconButton(
              onPressed: _saving ? null : _delete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remover',
            ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _saving,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Preview do avatar (igual à UX dos usuários)
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: _avatar.text.isNotEmpty
                        ? NetworkImage(_avatar.text)
                        : null,
                    child: _avatar.text.isEmpty
                        ? const Icon(Icons.business, size: 42)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Informe o email';
                    final emailOk =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                    return emailOk ? null : 'Email inválido';
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _avatar,
                  decoration:
                      const InputDecoration(labelText: 'URL do Avatar (opcional)'),
                  onChanged: (_) => setState(() {}), // atualiza preview
                ),
                const SizedBox(height: 8),

                SwitchListTile(
                  title: const Text('Ativo'),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
                const SizedBox(height: 16),

                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(editing ? 'Salvar alterações' : 'Criar cliente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
