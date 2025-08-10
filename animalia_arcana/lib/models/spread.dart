class SpreadModel {
  final String id;
  final String name;
  final int cardCount;
  final List<String> positions;
  final List<String>? positionMeanings; // optional

  const SpreadModel({
    required this.id,
    required this.name,
    required this.cardCount,
    required this.positions,
    this.positionMeanings,
  });

  factory SpreadModel.fromJson(Map<String, dynamic> json) => SpreadModel(
        id: json['id'] as String,
        name: json['name'] as String,
        cardCount: json['cardCount'] as int,
        positions: (json['positions'] as List<dynamic>).cast<String>(),
        positionMeanings: json['positionMeanings'] != null
            ? (json['positionMeanings'] as List<dynamic>).cast<String>()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cardCount': cardCount,
        'positions': positions,
        if (positionMeanings != null) 'positionMeanings': positionMeanings,
      };
}