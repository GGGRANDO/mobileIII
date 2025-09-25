
class Client {
  final String? id;
  final String cnpj;
  final String razaoSocial;
  final String nomeFantasia;
  final String regimeTributario;
  final String email;
  final String telefone;
  final String endereco;

  Client({
    this.id,
    required this.cnpj,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.regimeTributario,
    required this.email,
    required this.telefone,
    required this.endereco,
  });
//atalho de boa prática de programação, feito para alter apenas alguns campos e não precisar criar do zero
  Client copyWith({
    String? id,
    String? cnpj,
    String? razaoSocial,
    String? nomeFantasia,
    String? regimeTributario,
    String? email,
    String? telefone,
    String? endereco,
  }) {
    return Client(
      id: id ?? this.id,
      cnpj: cnpj ?? this.cnpj,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      nomeFantasia: nomeFantasia ?? this.nomeFantasia,
      regimeTributario: regimeTributario ?? this.regimeTributario,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      endereco: endereco ?? this.endereco,
    );
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String?,
      cnpj: json['cnpj'] ?? '',
      razaoSocial: json['razaoSocial'] ?? '',
      nomeFantasia: json['nomeFantasia'] ?? '',
      regimeTributario: json['regimeTributario'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? '',
    );
  }
//só manda pra api se existir ID
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, 
      'cnpj': cnpj,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'regimeTributario': regimeTributario,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
    };
  }
}
