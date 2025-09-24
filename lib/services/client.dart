import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class ClientService {
  static const String baseUrl =
      'https://68d33883cc7017eec5464534.mockapi.io/ClientService';
  ClientService();

  Uri _uri(String path, [Map<String, dynamic>? query]) => Uri.parse(
    '$baseUrl$path',
  ).replace(queryParameters: query?.map((k, v) => MapEntry(k, v?.toString())));

  Future<List<Client>> getClients() async {
    final res = await http.get(_uri('/clients'));
    if (res.statusCode == 200) {
      final List list = json.decode(res.body) as List;
      return list.map((e) => Client.fromJson(e)).toList();
    }
    throw Exception('Falha ao carregar clientes (${res.statusCode})');
  }

  Future<Client> getClient(String id) async {
    final res = await http.get(_uri('/clients/$id'));
    if (res.statusCode == 200) {
      return Client.fromJson(json.decode(res.body));
    }
    throw Exception('Falha ao carregar cliente (${res.statusCode})');
  }

  Future<Client> createClient(Client client) async {
    final res = await http.post(
      _uri('/clients'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Client.fromJson(json.decode(res.body));
    }
    throw Exception('Falha ao criar cliente (${res.statusCode})');
  }

  Future<Client> updateClient(Client client) async {
    if (client.id == null) throw Exception('Cliente sem ID');
    final res = await http.put(
      _uri('/clients/${client.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (res.statusCode == 200) {
      return Client.fromJson(json.decode(res.body));
    }
    throw Exception('Falha ao atualizar cliente (${res.statusCode})');
  }

  Future<void> deleteClient(String id) async {
    final res = await http.delete(_uri('/clients/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Falha ao remover cliente (${res.statusCode})');
    }
  }
}
