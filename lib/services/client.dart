import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client.dart';

class ClientService {
  static const _key = 'clients';
  List<Client> _clients = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _clients = jsonList.map((e) => Client.fromJson(e)).toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_clients.map((c) => c.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<List<Client>> getClients() async {
    return _clients;
  }

  Future<void> createClient(Client client) async {
    final newClient = client.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _clients.add(newClient);
    await _save();
  }

  Future<void> updateClient(Client client) async {
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      _clients[index] = client;
      await _save();
    }
  }

  Future<void> deleteClient(String id) async {
    _clients.removeWhere((c) => c.id == id);
    await _save();
  }
}
