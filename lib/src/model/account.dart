class Account {
  final String id;
  final String name;
  final String description;

  Account({required this.id, required this.name, required this.description});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        id: json['id'], name: json['name'], description: json['description']);
  }
}
