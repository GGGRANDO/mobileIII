import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/themeProvider.dart';
import '../models/user.dart';
import '../services/user.dart';
import 'userFormPage.dart';
import '../routes.dart';

class UserListPage extends StatefulWidget {
  final UserService service;
  const UserListPage({super.key, required this.service});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _future = widget.service.getUsers();
    });
  }

  Future<void> _goToEdit(User u) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => UserFormPage(service: widget.service, initial: u),
      ),
    );
    if (changed == true) _reload();
  }

  Widget _userCard(User u) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _goToEdit(u),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'user-avatar-${u.id}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: (u.avatar.isNotEmpty)
                      ? NetworkImage(u.avatar)
                      : null,
                  child: u.avatar.isEmpty ? const Icon(Icons.person) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    u.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(u.email),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Usuários'),
            backgroundColor: theme.appBarColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: theme.appBarColor,
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.userNew).then((changed) {
                  if (changed == true) _reload();
                }),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Novo'),
          ),
          body: RefreshIndicator(
            onRefresh: () async => _reload(),
            child: FutureBuilder<List<User>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 48),
                            const SizedBox(height: 8),
                            Text('Erro ao carregar: ${snapshot.error}'),
                            const SizedBox(height: 8),
                            FilledButton.icon(
                              onPressed: _reload,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                final users = snapshot.data ?? [];
                if (users.isEmpty) {
                  return ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Nenhum usuário encontrado')),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (_, i) => _userCard(users[i]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
