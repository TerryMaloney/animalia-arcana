import 'dart:math';
import '../models/tarot_card.dart';
import '../models/reading.dart';
import '../data/card_data.dart';

class TarotService {
  static final Random _random = Random();

  // Fisher-Yates shuffle algorithm for realistic card shuffling
  static List<TarotCard> shuffleDeck() {
    List<TarotCard> deck = CardData.getAllCards();
    for (int i = deck.length - 1; i > 0; i--) {
      int j = _random.nextInt(i + 1);
      TarotCard temp = deck[i];
      deck[i] = deck[j];
      deck[j] = temp;
    }
    return deck;
  }

  // Draw a single card with random orientation
  static ReadingCard drawSingleCard() {
    List<TarotCard> deck = shuffleDeck();
    TarotCard card = deck.first;
    bool isReversed = _random.nextBool();
    return ReadingCard(
      card: card,
      orientation: isReversed ? 'reversed' : 'upright',
      position: 'Single Card',
    );
  }

  // Draw multiple cards for spreads
  static List<ReadingCard> drawCards(int count) {
    List<TarotCard> deck = shuffleDeck();
    List<ReadingCard> cards = [];
    
    for (int i = 0; i < count && i < deck.length; i++) {
      bool isReversed = _random.nextBool();
      cards.add(ReadingCard(
        card: deck[i],
        orientation: isReversed ? 'reversed' : 'upright',
        position: 'Card ${i + 1}',
      ));
    }
    
    return cards;
  }

  // Three card spread (Past-Present-Future)
  static List<ReadingCard> threeCardSpread() {
    List<ReadingCard> cards = drawCards(3);
    
    // Assign positions
    if (cards.length >= 3) {
      cards[0] = ReadingCard(
        card: cards[0].card,
        orientation: cards[0].orientation,
        position: 'Past',
      );
      cards[1] = ReadingCard(
        card: cards[1].card,
        orientation: cards[1].orientation,
        position: 'Present',
      );
      cards[2] = ReadingCard(
        card: cards[2].card,
        orientation: cards[2].orientation,
        position: 'Future',
      );
    }
    
    return cards;
  }

  // Celtic Cross spread (10 cards)
  static List<ReadingCard> celticCrossSpread() {
    List<ReadingCard> cards = drawCards(10);
    
    // Assign positions for Celtic Cross
    if (cards.length >= 10) {
      final positions = [
        'Present Situation',
        'Challenge',
        'Past Foundation',
        'Recent Past',
        'Possible Outcome',
        'Near Future',
        'Your Approach',
        'External Influences',
        'Hopes & Fears',
        'Final Outcome',
      ];
      
      for (int i = 0; i < 10; i++) {
        cards[i] = ReadingCard(
          card: cards[i].card,
          orientation: cards[i].orientation,
          position: positions[i],
        );
      }
    }
    
    return cards;
  }

  // Get daily card (with persistence check)
  static TarotCard getDailyCard() {
    List<TarotCard> deck = CardData.getAllCards();
    return deck[_random.nextInt(deck.length)];
  }

  // Get all cards (static version)
  static List<TarotCard> getAllCards() {
    return CardData.getAllCards();
  }

  // Search cards by query
  static List<TarotCard> searchCards(String query) {
    return CardData.searchCards(query);
  }

  // Get cards by suit
  static List<TarotCard> getCardsBySuit(String suit) {
    return CardData.getCardsBySuit(suit);
  }

  // Get major arcana only
  static List<TarotCard> getMajorArcana() {
    return CardData.getMajorArcana();
  }

  // Get minor arcana only
  static List<TarotCard> getMinorArcana() {
    return CardData.getMinorArcana();
  }

  // Get a random card
  static TarotCard getRandomCard() {
    List<TarotCard> deck = CardData.getAllCards();
    return deck[_random.nextInt(deck.length)];
  }

  // Get card by ID
  static TarotCard? getCardById(int id) {
    return CardData.getCardById(id);
  }


  // Perform a reading
  Future<Reading> performReading(String type, String question) async {
    List<ReadingCard> cards = [];
    
    switch (type) {
      case 'single':
        cards = [drawSingleCard()];
        break;
      case 'three_card':
        cards = threeCardSpread();
        break;
      case 'celtic_cross':
        cards = celticCrossSpread();
        break;
      default:
        cards = [drawSingleCard()];
    }
    
    String interpretation = generateReadingInterpretation(cards, type);
    
    return Reading(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      date: DateTime.now(),
      cards: cards,
      question: question,
      interpretation: interpretation,
    );
  }

  // Generate reading interpretation
  static String generateReadingInterpretation(List<ReadingCard> cards, String type) {
    if (cards.isEmpty) return 'No cards drawn.';
    
    String interpretation = '';
    
    switch (type) {
      case 'single':
        interpretation = _interpretSingleCard(cards.first);
        break;
      case 'three_card':
        interpretation = _interpretThreeCardSpread(cards);
        break;
      case 'celtic_cross':
        interpretation = _interpretCelticCross(cards);
        break;
      default:
        interpretation = _interpretGeneralReading(cards);
    }
    
    return interpretation;
  }

  static String _interpretSingleCard(ReadingCard card) {
    String orientation = card.isReversed ? 'Reversed' : 'Upright';
    return 'The ${card.card.displayName} appears $orientation. ${card.meaning}';
  }

  static String _interpretThreeCardSpread(List<ReadingCard> cards) {
    if (cards.length < 3) return 'Incomplete spread.';
    
    String interpretation = 'Your three-card journey reveals:\n\n';
    interpretation += 'Past: ${cards[0].card.displayName} (${cards[0].orientation})\n';
    interpretation += '${cards[0].meaning}\n\n';
    interpretation += 'Present: ${cards[1].card.displayName} (${cards[1].orientation})\n';
    interpretation += '${cards[1].meaning}\n\n';
    interpretation += 'Future: ${cards[2].card.displayName} (${cards[2].orientation})\n';
    interpretation += cards[2].meaning;
    
    return interpretation;
  }

  static String _interpretCelticCross(List<ReadingCard> cards) {
    if (cards.length < 10) return 'Incomplete Celtic Cross spread.';
    
    String interpretation = 'Your Celtic Cross reading reveals:\n\n';
    
    final positions = [
      'Present Situation', 'Challenge', 'Past Foundation', 'Recent Past',
      'Possible Outcome', 'Near Future', 'Your Approach', 'External Influences',
      'Hopes & Fears', 'Final Outcome'
    ];
    
    for (int i = 0; i < 10 && i < cards.length; i++) {
      interpretation += '${positions[i]}: ${cards[i].card.displayName} (${cards[i].orientation})\n';
      interpretation += '${cards[i].meaning}\n\n';
    }
    
    return interpretation;
  }

  static String _interpretGeneralReading(List<ReadingCard> cards) {
    String interpretation = 'Your reading reveals:\n\n';
    
    for (int i = 0; i < cards.length; i++) {
      interpretation += 'Card ${i + 1}: ${cards[i].card.displayName} (${cards[i].orientation})\n';
      interpretation += '${cards[i].meaning}\n\n';
    }
    
    return interpretation;
  }
} 