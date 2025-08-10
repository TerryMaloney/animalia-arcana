import 'tarot_card.dart';

class ReadingCard {
  final TarotCard card;
  final String orientation; // 'upright' or 'reversed'
  final String position; // e.g., 'past', 'present', 'future'

  const ReadingCard({
    required this.card,
    required this.orientation,
    required this.position,
  });

  factory ReadingCard.fromJson(Map<String, dynamic> json) {
    return ReadingCard(
      card: TarotCard.fromJson(json['card'] as Map<String, dynamic>),
      orientation: json['orientation'] as String,
      position: json['position'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card': card.toJson(),
      'orientation': orientation,
      'position': position,
    };
  }
}

class Reading {
  final String id;
  final String type; // 'single', 'three_card', 'celtic_cross', 'daily'
  final DateTime date;
  final List<ReadingCard> cards;
  final String question;
  final String interpretation;

  const Reading({
    required this.id,
    required this.type,
    required this.date,
    required this.cards,
    required this.question,
    required this.interpretation,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      id: json['id'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      cards: (json['cards'] as List<dynamic>)
          .map((card) => ReadingCard.fromJson(card as Map<String, dynamic>))
          .toList(),
      question: json['question'] as String,
      interpretation: json['interpretation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'cards': cards.map((card) => card.toJson()).toList(),
      'question': question,
      'interpretation': interpretation,
    };
  }
}