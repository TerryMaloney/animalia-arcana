class CardDataModel {
  final String name;
  final String imagePath;
  final String meaning; // default/upright meaning for current UI
  final String? id;
  final String? uprightMeaning;
  final String? reversedMeaning;

  const CardDataModel({
    required this.name,
    required this.imagePath,
    required this.meaning,
    this.id,
    this.uprightMeaning,
    this.reversedMeaning,
  });

  // Supports legacy schema {name, imagePath, meaning}
  // and new schema card: {id, name, image, upright, reversed}, with deck.imageBasePath
  factory CardDataModel.fromJson(Map<String, dynamic> json, {String? imageBasePath}) {
    if (json.containsKey('image') || json.containsKey('upright') || json.containsKey('reversed')) {
      final base = imageBasePath ?? '';
      final image = json['image'] as String? ?? '';
      final upr = json['upright'] as String?;
      final rev = json['reversed'] as String?;
      return CardDataModel(
        id: json['id'] as String?,
        name: json['name'] as String? ?? 'Unknown',
        imagePath: base.isNotEmpty ? '$base$image' : image,
        meaning: upr ?? json['meaning'] as String? ?? '',
        uprightMeaning: upr,
        reversedMeaning: rev,
      );
    }
    return CardDataModel(
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      meaning: json['meaning'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'meaning': meaning,
        if (uprightMeaning != null) 'upright': uprightMeaning,
        if (reversedMeaning != null) 'reversed': reversedMeaning,
      };
}

class DeckModel {
  final String id;
  final String name;
  final List<CardDataModel> cards;
  final String? imageBasePath;

  const DeckModel({
    required this.id,
    required this.name,
    required this.cards,
    this.imageBasePath,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    final base = json['imageBasePath'] as String?;
    final rawCards = (json['cards'] as List<dynamic>? ?? const <dynamic>[])
        .map((c) => CardDataModel.fromJson(c as Map<String, dynamic>, imageBasePath: base))
        .toList();
    return DeckModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cards: rawCards,
      imageBasePath: base,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (imageBasePath != null) 'imageBasePath': imageBasePath,
        'cards': cards.map((c) => c.toJson()).toList(),
      };
}