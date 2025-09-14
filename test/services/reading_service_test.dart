import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/tarot_service.dart';
import '../../lib/models/tarot_card.dart';
import '../../lib/models/reading.dart';

class _FakeService extends TarotService {
  @override
  Future<List<TarotCard>> loadDeck() async => [
        TarotCard(
          id: 'wolf',
          name: 'Wolf',
          suit: 'Major',
          number: 0,
          uprightMeaning: 'Instinct and guidance.',
          reversedMeaning: 'Isolation.',
          imageAsset: 'assets/cards/wolf.png',
        ),
        TarotCard(
          id: 'owl',
          name: 'Owl',
          suit: 'Swords',
          number: 3,
          uprightMeaning: 'Wisdom.',
          reversedMeaning: 'Paralysis by analysis.',
          imageAsset: 'assets/cards/owl.png',
        ),
      ];

  @override
  Future<Reading> drawOneCard({bool allowReversed = true}) async {
    final deck = await loadDeck();
    final card = deck.first;
    return Reading.single(card: card, reversed: false, timestamp: DateTime(2025));
  }
}

void main() {
  test('TarotService basic reading', () async {
    final svc = _FakeService();
    final r = await svc.drawOneCard();

    expect(r.cards.length, 1);
    expect(r.cards.first.card.id, 'wolf');
    expect(r.displayType, isNotEmpty);
    expect(r.formattedDate, contains('2025'));
  });
}
