class TarotCard {
  final int id;
  final String name;
  final String animal;
  final String type; // 'major' or 'minor'
  final String suit; // 'major_arcana', 'wands', 'cups', 'swords', 'pentacles'
  final int number;
  final String imagePath;
  final String keywords;
  final String uprightMeaning;
  final String reversedMeaning;

  TarotCard({
    required this.id,
    required this.name,
    required this.animal,
    required this.type,
    required this.suit,
    required this.number,
    required this.imagePath,
    required this.keywords,
    required this.uprightMeaning,
    required this.reversedMeaning,
  });

  factory TarotCard.fromMap(Map<String, dynamic> map) {
    return TarotCard(
      id: map['id'],
      name: map['name'],
      animal: map['animal'],
      type: map['type'],
      suit: map['suit'],
      number: map['number'],
      imagePath: map['image_path'],
      keywords: map['keywords'],
      uprightMeaning: map['upright_meaning'],
      reversedMeaning: map['reversed_meaning'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'animal': animal,
      'type': type,
      'suit': suit,
      'number': number,
      'image_path': imagePath,
      'keywords': keywords,
      'upright_meaning': uprightMeaning,
      'reversed_meaning': reversedMeaning,
    };
  }

  String get displayName => '$name - $animal';
  String get shortName => name;
  bool get isMajorArcana => type == 'major';
  bool get isMinorArcana => type == 'minor';
} 