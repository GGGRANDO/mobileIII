// Este arquivo contém o serviço que conversa com a API
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class ClientService {
  // URL base da API (MockAPI)
  static const String baseUrl = "https://68d3798e214be68f8c65f180.mockapi.io/clientes";

  // Busca todos os clientes
  Future<List<Client>> getClients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Client.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar clientes: ${response.statusCode}");
    }
  }

  // Cria um cliente na API
  Future<void> createClient(Client client) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao criar cliente: ${response.statusCode}");
    }
  }

  // Atualiza um cliente existente
  Future<void> updateClient(Client client) async {
    if (client.id == null) throw Exception("ID do cliente é nulo");

    final response = await http.put(
      Uri.parse("$baseUrl/${client.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar cliente: ${response.statusCode}");
    }
  }

  // Exclui um cliente
  Future<void> deleteClient(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Erro ao excluir cliente: ${response.statusCode}");
    }
  }
}
