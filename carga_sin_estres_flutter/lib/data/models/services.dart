class Services {
  final String name;
  final String description;

  Services({
    required this.name,
    required this.description,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
    );
  }
}
