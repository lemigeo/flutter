class User {
  final int seq;
  final String serviceType;
  final String email;
  final String name;
  final String type;

  User(
      {required this.seq,
      required this.serviceType,
      required this.email,
      required this.name,
      required this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      seq: json['seq'],
      serviceType: 'GCP',
      email: json['email'],
      name: json['name'],
      type: json['type'],
    );
  }
}
