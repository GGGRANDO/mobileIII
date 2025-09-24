import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user.dart';

class UserFormPage extends StatefulWidget {
  final UserService service;
  final User? initial;

  const UserFormPage({super.key, required this.service, this.initial});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _username;
  late TextEditingController _password;
  late TextEditingController _email;
  late TextEditingController _avatar;
  DateTime? _birthday;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.name ?? '');
    _username = TextEditingController(text: widget.initial?.username ?? '');
    _password = TextEditingController(text: widget.initial?.password ?? '');
    _email = TextEditingController(text: widget.initial?.email ?? '');
    _avatar = TextEditingController(text: widget.initial?.avatar ?? '');
    _birthday = widget.initial?.birthday;
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _password.dispose();
    _email.dispose();
    _avatar.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _birthday ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _birthday = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final model = User(
      id: widget.initial?.id,
      name: _name.text.trim(),
      username: _username.text.trim(),
      password: _password.text,
      email: _email.text.trim(),
      avatar: _avatar.text.trim(),
      birthday: _birthday,
    );
    if (widget.initial == null) {
      await widget.service.createUser(model);
    } else {
      await widget.service.updateUser(model);
    }
    if (mounted) Navigator.of(context).pop(true);
    setState(() => _saving = false);
  }

  Future<void> _delete() async {
    if (widget.initial?.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover usuário'),
        content: const Text('Tem certeza que deseja remover este usuário?'),
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
    await widget.service.deleteUser(widget.initial!.id!);
    if (mounted) Navigator.of(context).pop(true);
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar Usuário' : 'Novo Usuário'),
        actions: [
          if (editing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _saving ? null : _delete,
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
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                ),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o usuário'
                      : null,
                ),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe a senha' : null,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Informe o email';
                    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
                        ? null
                        : 'Email inválido';
                  },
                ),
                TextFormField(
                  controller: _avatar,
                  decoration: const InputDecoration(labelText: 'URL do Avatar'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aniversário'),
                  subtitle: Text(
                    _birthday != null
                        ? '${_birthday!.day.toString().padLeft(2, '0')}/${_birthday!.month.toString().padLeft(2, '0')}/${_birthday!.year}'
                        : 'Não informado',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(editing ? 'Salvar alterações' : 'Criar usuário'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
