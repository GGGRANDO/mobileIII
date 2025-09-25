import 'package:flutter/material.dart';
import '../services/client.dart';
import '../models/client.dart';
import 'clientFormPage.dart';

class ClientListFindPage extends StatefulWidget {
  final ClientService service;
  const ClientListFindPage({super.key, required this.service});

  @override
  State<ClientListFindPage> createState() => _ClientListFindPageState();
}

class _ClientListFindPageState extends State<ClientListFindPage> {
  late Future<List<Client>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.service.getClients();
  }

  void _reload() {
    setState(() {
      _future = widget.service.getClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes (Busca)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar cliente...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) => setState(() => _query = text),
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
                if (_query.isNotEmpty) {
                  clients = clients.where((c) =>
                      c.razaoSocial.toLowerCase().contains(_query.toLowerCase()) ||
                      c.nomeFantasia.toLowerCase().contains(_query.toLowerCase())
                  ).toList();
                }

                if (clients.isEmpty) {
                  return const Center(child: Text("Escreveu errado patrão"));
                }

                return ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (_, i) {
                    final c = clients[i];
                    return ListTile(
                      title: Text(c.razaoSocial),
                      subtitle: Text(c.email),
                      onTap: () async {
                        final changed = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ClientFormPage(service: widget.service, initial: c),
                          ),
                        );
                        if (changed == true) _reload();
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
