class Services {
  final int id;
  final String name;

  Services({
    required this.id,
    required this.name,
  });

  factory Services.fromJson(Map<String, dynamic> json,
      {required Map<String, Object> extraJson,
      required Map<String, Object> additionalJson}) {
    return Services(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
