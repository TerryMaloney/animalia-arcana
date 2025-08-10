class TarotCard {
  final String name;
  final String animal;
  final String suit;
  final int number;
  final String description;
  final String uprightMeaning;
  final String reversedMeaning;
  final String keywords;

  const TarotCard({
    required this.name,
    required this.animal,
    required this.suit,
    required this.number,
    required this.description,
    required this.uprightMeaning,
    required this.reversedMeaning,
    required this.keywords,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      name: json['name'] as String,
      animal: json['animal'] as String,
      suit: json['suit'] as String,
      number: json['number'] as int,
      description: json['description'] as String,
      uprightMeaning: json['uprightMeaning'] as String,
      reversedMeaning: json['reversedMeaning'] as String,
      keywords: json['keywords'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'animal': animal,
      'suit': suit,
      'number': number,
      'description': description,
      'uprightMeaning': uprightMeaning,
      'reversedMeaning': reversedMeaning,
      'keywords': keywords,
    };
  }
} 