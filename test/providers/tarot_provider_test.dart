import 'package:flutter_test/flutter_test.dart';
import '../../lib/providers/tarot_provider.dart';
import '../../lib/services/tarot_service.dart';
import '../../lib/models/tarot_card.dart';
import '../../lib/models/reading.dart';

class _Svc extends TarotService {
  @override
  Future<List<TarotCard>> loadDeck() async => [
        TarotCard(
          id: 'bear',
          name: 'Bear',
          suit: 'Cups',
          number: 5,
          uprightMeaning: 'Protection.',
          reversedMeaning: 'Overprotection.',
          imageAsset: 'assets/cards/bear.png',
        )
      ];

  @override
  Future<Reading> drawOneCard({bool allowReversed = true}) async {
    final c = (await loadDeck()).first;
    return Reading.single(card: c, reversed: false, timestamp: DateTime.now());
  }
}

void main() {
  test('TarotProvider loads deck and draws daily', () async {
    final p = TarotProvider(service: _Svc());

    expect(p.isLoading, true);
    await p.initialize();
    expect(p.isLoading, false);
    expect(p.deck.isNotEmpty, true);

    await p.drawDailyCard();
    expect(p.dailyCard, isNotNull);
    expect(p.history.length, 1);
  });
}
