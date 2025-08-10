import 'dart:math';
import '../models/tarot_card.dart';
import '../models/reading.dart';
import '../data/card_data.dart';

class TarotService {
  static final Random _random = Random();

  // Fisher-Yates shuffle algorithm
  static List<TarotCard> shuffleDeck(List<TarotCard> deck) {
    final shuffled = List<TarotCard>.from(deck);
    for (int i = shuffled.length - 1; i > 0; i--) {
      int j = _random.nextInt(i + 1);
      TarotCard temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  static List<TarotCard> getShuffledDeck() {
    final allCards = CardData.getAllCards();
    return shuffleDeck(allCards);
  }

  static TarotCard drawCard(List<TarotCard> deck) {
    if (deck.isEmpty) {
      throw Exception('Cannot draw from empty deck');
    }
    return deck.removeAt(0);
  }

  static List<TarotCard> drawCards(List<TarotCard> deck, int count) {
    if (deck.length < count) {
      throw Exception('Not enough cards in deck');
    }
    final drawn = <TarotCard>[];
    for (int i = 0; i < count; i++) {
      drawn.add(drawCard(deck));
    }
    return drawn;
  }

  static bool isReversed() {
    return _random.nextBool();
  }

  static ReadingCard createReadingCard(TarotCard card, String position) {
    final orientation = isReversed() ? 'reversed' : 'upright';
    return ReadingCard(
      card: card,
      orientation: orientation,
      position: position,
    );
  }

  static Future<Reading> performSingleCardReading(String question) async {
    print('🔄 TarotService: Starting single card reading');
    final deck = getShuffledDeck();
    final card = drawCard(deck);
    final readingCard = createReadingCard(card, 'focus');
    
    final interpretation = _interpretSingleCard(readingCard);
    
    final reading = Reading(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'single',
      date: DateTime.now(),
      cards: [readingCard],
      question: question,
      interpretation: interpretation,
    );
    
    print('✅ TarotService: Single card reading completed');
    return reading;
  }

  static Future<Reading> performThreeCardReading(String question) async {
    print('🔄 TarotService: Starting three card reading');
    final deck = getShuffledDeck();
    final cards = drawCards(deck, 3);
    
    final readingCards = [
      createReadingCard(cards[0], 'past'),
      createReadingCard(cards[1], 'present'),
      createReadingCard(cards[2], 'future'),
    ];
    
    final interpretation = _interpretThreeCards(readingCards);
    
    final reading = Reading(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'three_card',
      date: DateTime.now(),
      cards: readingCards,
      question: question,
      interpretation: interpretation,
    );
    
    print('✅ TarotService: Three card reading completed');
    return reading;
  }

  static Future<Reading> performCelticCrossReading(String question) async {
    print('🔄 TarotService: Starting Celtic Cross reading');
    final deck = getShuffledDeck();
    final cards = drawCards(deck, 10);
    
    final positions = [
      'situation', 'challenge', 'past', 'future', 'above',
      'below', 'advice', 'external', 'hopes', 'outcome'
    ];
    
    final readingCards = <ReadingCard>[];
    for (int i = 0; i < cards.length; i++) {
      readingCards.add(createReadingCard(cards[i], positions[i]));
    }
    
    final interpretation = _interpretCelticCross(readingCards);
    
    final reading = Reading(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'celtic_cross',
      date: DateTime.now(),
      cards: readingCards,
      question: question,
      interpretation: interpretation,
    );
    
    print('✅ TarotService: Celtic Cross reading completed');
    return reading;
  }

  static Future<Reading> performDailyReading() async {
    print('🔄 TarotService: Starting daily reading');
    final deck = getShuffledDeck();
    final card = drawCard(deck);
    final readingCard = createReadingCard(card, 'daily');
    
    final interpretation = _interpretDailyCard(readingCard);
    
    final reading = Reading(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'daily',
      date: DateTime.now(),
      cards: [readingCard],
      question: 'What message do I need today?',
      interpretation: interpretation,
    );
    
    print('✅ TarotService: Daily reading completed');
    return reading;
  }

  static String _interpretSingleCard(ReadingCard readingCard) {
    final card = readingCard.card;
    final isReversed = readingCard.orientation == 'reversed';
    final meaning = isReversed ? card.reversedMeaning : card.uprightMeaning;
    
    return '${card.name} (${card.animal}) - ${isReversed ? 'Reversed' : 'Upright'}\n\n$meaning';
  }

  static String _interpretThreeCards(List<ReadingCard> cards) {
    String interpretation = 'Past: ${cards[0].card.name} (${cards[0].card.animal}) - ${cards[0].orientation}\n';
    interpretation += 'Present: ${cards[1].card.name} (${cards[1].card.animal}) - ${cards[1].orientation}\n';
    interpretation += 'Future: ${cards[2].card.name} (${cards[2].card.animal}) - ${cards[2].orientation}\n\n';
    
    interpretation += 'This spread shows your journey from past influences through current circumstances to future possibilities. ';
    interpretation += 'Consider how these energies flow together to guide your path forward.';
    
    return interpretation;
  }

  static String _interpretCelticCross(List<ReadingCard> cards) {
    String interpretation = 'Celtic Cross Reading:\n\n';
    interpretation += '1. Situation: ${cards[0].card.name} (${cards[0].orientation})\n';
    interpretation += '2. Challenge: ${cards[1].card.name} (${cards[1].orientation})\n';
    interpretation += '3. Past: ${cards[2].card.name} (${cards[2].orientation})\n';
    interpretation += '4. Future: ${cards[3].card.name} (${cards[3].orientation})\n';
    interpretation += '5. Above: ${cards[4].card.name} (${cards[4].orientation})\n';
    interpretation += '6. Below: ${cards[5].card.name} (${cards[5].orientation})\n';
    interpretation += '7. Advice: ${cards[6].card.name} (${cards[6].orientation})\n';
    interpretation += '8. External: ${cards[7].card.name} (${cards[7].orientation})\n';
    interpretation += '9. Hopes: ${cards[8].card.name} (${cards[8].orientation})\n';
    interpretation += '10. Outcome: ${cards[9].card.name} (${cards[9].orientation})\n\n';
    
    interpretation += 'This comprehensive reading reveals the deeper patterns and influences in your situation. ';
    interpretation += 'Take time to reflect on how each position relates to your question.';
    
    return interpretation;
  }

  static String _interpretDailyCard(ReadingCard readingCard) {
    final card = readingCard.card;
    final isReversed = readingCard.orientation == 'reversed';
    final meaning = isReversed ? card.reversedMeaning : card.uprightMeaning;
    
    return 'Today\'s Card: ${card.name} (${card.animal})\n\n$meaning\n\nThis card offers guidance for your day ahead.';
  }
} 