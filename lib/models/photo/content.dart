class Content {
  final String type;
  final String? pattern;
  final String heading;
  final String defaultValue;
  final int minCharacters;
  final int maxCharacters;
  final double? position;

  Content({
    required this.type,
    required this.pattern,
    required this.heading,
    required this.defaultValue,
    required this.minCharacters,
    required this.maxCharacters,
    required this.position,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
        type: json['typ'] as String,
        pattern: json['wzor'] != null ? json['wzor'] as String : null,
        heading: json['naglowek'] as String,
        defaultValue: json['domyslna_wartosc'] as String,
        minCharacters: int.parse(json['znakow_min']),
        maxCharacters: int.parse(json['znakow_max']),
        position: json['poz'] != null ? double.parse(json['poz']) : null);
  }
}
