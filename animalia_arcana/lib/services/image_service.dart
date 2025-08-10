import '../models/tarot_card.dart';

class ImageService {
  static const String _basePath = 'assets/images/cards/';
  
  // Mapping of card names to image files
  static final Map<String, String> _cardImageMap = {
    'The Fool': 'Butterfly.jpg',
    'The Magician': 'Fox.jpg',
    'The High Priestess': 'Owl.jpg',
    'The Empress': 'Cow.jpg',
    'The Emperor': 'Lion.jpg',
    'The Hierophant': 'Elephant.jpg',
    'The Lovers': 'Swans.jpg',
    'The Chariot': 'Horse.jpg',
    'Strength': 'Bear.jpg',
    'The Hermit': 'Tortoise.jpg',
    'Wheel of Fortune': 'Snake.jpg',
    'Justice': 'Eagle.jpg',
    'The Hanged Man': 'Bat.jpg',
    'Death': 'Scorpion.jpg',
    'Temperance': 'Heron.jpg',
    'The Devil': 'Goat.jpg',
    'The Tower': 'Vulture.jpg',
    'The Star': 'Deer.jpg',
    'The Moon': 'Wolf.jpg',
    'The Sun': 'Rooster.jpg',
    'Judgement': 'Pheonix.jpg',
    'The World': 'Whale.jpg',
    'Ace of Wands': 'Dragon.jpg',
    'Two of Wands': 'Tiger.jpg',
    'Three of Wands': 'Coyote.jpg',
    'Ace of Cups': 'Dolphin.jpg',
    'Ace of Pentacles': 'Wild Boar.jpg',
    'Ace of Swords': 'Stag.jpg',
  };

  static String getCardImagePath(TarotCard card) {
    print('🔍 ImageService: Looking up image for card "${card.name}"');
    final imageFile = _cardImageMap[card.name];
    if (imageFile != null) {
      final path = '$_basePath$imageFile';
      print('✅ ImageService: Found mapping "${card.name}" -> "$imageFile"');
      print('📁 ImageService: Full path: $path');
      return path;
    }
    final fallbackPath = '$_basePath${card.animal}.jpg';
    print('⚠️ ImageService: No mapping found for "${card.name}", using fallback: $fallbackPath');
    return fallbackPath;
  }

  static String getAnimalImagePath(String animalName) {
    return '$_basePath$animalName.jpg';
  }

  static bool hasImageForCard(TarotCard card) {
    return _cardImageMap.containsKey(card.name) || 
           _cardImageMap.values.any((filename) => filename.toLowerCase().contains(card.animal.toLowerCase()));
  }
} 