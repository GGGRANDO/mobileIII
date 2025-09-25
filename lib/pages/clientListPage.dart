import 'dart:async';
import 'package:flutter/material.dart';
import '../services/client.dart';
import '../models/client.dart';
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
  final _searchCtrl = TextEditingController(); // controller da busca
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.service.getClients();
    // Simula splash
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _showSplash = false);
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

  Future<void> _goToEdit(Client client) async {
    final changed = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientFormPage(service: widget.service, initial: client),
      ),
    );
    if (changed == true) _reload();
  }

  Widget _clientCard(Client c) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        onTap: () => _goToEdit(c),
        leading: CircleAvatar(
          child: Text(c.nomeFantasia.isNotEmpty ? c.nomeFantasia[0] : '?'),
        ),
        title: Text(c.razaoSocial),
        subtitle: Text(c.email),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            try {
              await widget.service.deleteClient(c.id!);
              _reload();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao excluir: $e')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final changed = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ClientFormPage(service: widget.service)),
          );
          if (changed == true) _reload();
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Campo de busca
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: "Buscar cliente...",
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
                  onChanged: (text) => setState(() => _query = text.trim()),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Client>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    }
                    var clients = snapshot.data ?? [];

                    // Aplica filtro
                    if (_query.isNotEmpty) {
                      clients = clients.where((c) =>
                        c.razaoSocial.toLowerCase().contains(_query.toLowerCase()) ||
                        c.nomeFantasia.toLowerCase().contains(_query.toLowerCase())
                      ).toList();
                    }

                    if (clients.isEmpty) {
                      return const Center(child: Text('Nenhum cliente encontrado'));
                    }

                    return RefreshIndicator(
                      onRefresh: () async => _reload(),
                      child: ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (_, i) => _clientCard(clients[i]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_showSplash)
            Container(
              color: Colors.white,
              child: const Center(child: Text("Carregando lista...")),
            ),
        ],
      ),
    );
  }
}
