class User {
  final String? id; // null enquanto ainda não foi criado
  String name;
  String email;
  String avatar;
  DateTime? birthday;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      birthday: json['birthday'] != null && json['birthday'] != ''
          ? DateTime.tryParse(json['birthday'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'birthday': birthday?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? birthday,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      birthday: birthday ?? this.birthday,
    );
  }
}
