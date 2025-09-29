class Tag {
  final String id;
  final String name;
  final int color; // ARGB(0xFFRRGGBB)

  const Tag({required this.id, required this.name, required this.color});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json['id'] as String, name: json['name'] as String, color: json['color'] as int);
}
