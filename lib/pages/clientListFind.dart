import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/themeProvider.dart';
import '../routes.dart';
import '../models/client.dart';
import '../services/client.dart';
import 'clientFormPage.dart';

class ClientListPage extends StatefulWidget {
  final ClientService service;
  const ClientListPage({super.key, required this.service});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  bool _showSplash = true;
  late Future<List<Client>> _future;

  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.service.getClients();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = widget.service.getClients();
    });
  }

  Future<void> _goToEdit(Client c) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ClientFormPage(service: widget.service, initial: c),
      ),
    );
    if (changed == true) _reload();
  }

  Widget _clientCard(Client c) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _goToEdit(c),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(
                  c.nomeFantasia.isNotEmpty ? c.nomeFantasia[0] : '?',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.nomeFantasia.isNotEmpty
                          ? c.nomeFantasia
                          : c.razaoSocial,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('CNPJ: ${c.cnpj}'),
                    Text('Regime: ${c.regimeTributario}'),
                    Text('Email: ${c.email}'),
                    Text('Telefone: ${c.telefone}'),
                    Text('Endereço: ${c.endereco}'),
                  ],
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: themeProvider.appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.clientsNew).then((changed) {
              if (changed == true) _reload();
            }),
        icon: const Icon(Icons.business),
        label: const Text('Novo'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome fantasia ou razão social...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (text) => setState(() => _query = text.trim()),
                  onSubmitted: (text) => setState(() => _query = text.trim()),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: FutureBuilder<List<Client>>(
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

                      var clients = snapshot.data ?? [];

                      if (_query.isNotEmpty) {
                        clients = clients
                            .where(
                              (c) =>
                                  c.nomeFantasia.toLowerCase().contains(
                                    _query.toLowerCase(),
                                  ) ||
                                  c.razaoSocial.toLowerCase().contains(
                                    _query.toLowerCase(),
                                  ),
                            )
                            .toList();
                      }

                      if (clients.isEmpty) {
                        return ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('Nenhum cliente encontrado')),
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (_, i) => _clientCard(clients[i]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_showSplash)
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.business, size: 96),
                  SizedBox(height: 16),
                  Text(
                    'Clientes',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Carregando lista...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
