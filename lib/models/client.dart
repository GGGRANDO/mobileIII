class Client {
  final String? id;
  String name;
  String email;
  String avatar;
  bool active;

  Client({
    this.id,
    required this.name,
    required this.email,
    this.avatar = '',
    this.active = true,
  });

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    bool? active,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      active: active ?? this.active,
    );
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is String) return v.toLowerCase() == 'true';
      if (v is num) return v != 0;
      return false;
    }

    return Client(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: (json['avatar'] ?? json['image'] ?? '').toString(),
      active: parseBool(json['active'] ?? true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'active': active,
    };
  }
}
