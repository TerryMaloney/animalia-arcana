import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/tarot_card.dart';

void main() {
  test('TarotCard JSON roundtrip', () {
    final original = TarotCard(
      id: 'the-fox',
      name: 'The Fox',
      suit: 'Wands',
      number: 7,
      uprightMeaning: 'Cleverness and agility.',
      reversedMeaning: 'Cunning becomes deceit.',
      imageAsset: 'assets/cards/fox.png',
    );

    final map = original.toJson();
    final again = TarotCard.fromJson(map);

    expect(again.id, original.id);
    expect(again.name, original.name);
    expect(again.suit, original.suit);
    expect(again.number, original.number);
    expect(again.uprightMeaning, original.uprightMeaning);
    expect(again.reversedMeaning, original.reversedMeaning);
    expect(again.imageAsset, original.imageAsset);
  });
}
