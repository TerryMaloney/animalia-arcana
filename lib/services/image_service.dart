import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/tarot_card.dart';

class ImageService {
  static const String _basePath = 'assets/images/cards/';
  
  // Card name to image file mapping
  static const Map<String, String> _cardImageMap = {
    // Major Arcana
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
    
    // Wands
    'Ace of Wands': 'Salamander.jpg',
    'Two of Wands': 'Falcon.jpg',
    'Three of Wands': 'Gazelle.jpg',
    'Four of Wands': 'Bee.jpg',
    'Five of Wands': 'Ram.jpg',
    'Six of Wands': 'Stag.jpg',
    'Seven of Wands': 'Wolverine.jpg',
    'Eight of Wands': 'Swallow.jpg',
    'Nine of Wands': 'Wild Boar.jpg',
    'Ten of Wands': 'Donkey.jpg',
    'Page of Wands': 'Coyote.jpg',
    'Knight of Wands': 'Tiger.jpg',
    'Queen of Wands': 'Lioness.jpg',
    'King of Wands': 'Dragon.jpg',
    
    // Cups
    'Ace of Cups': 'Dolphin.jpg',
    'Two of Cups': 'LoveBirds.jpg',
    'Three of Cups': 'Otters.jpg',
    'Four of Cups': 'Cat.jpg',
    'Five of Cups': 'Jelleyfish.jpg',
    'Six of Cups': 'Rabbits.jpg',
    'Seven of Cups': 'Octopus.jpg',
    'Eight of Cups': 'SeaTurtle.jpg',
    'Nine of Cups': 'KoiFish.jpg',
    'Ten of Cups': 'Flamingo.jpg',
    'Page of Cups': 'Seahorse.jpg',
    'Knight of Cups': 'Hummingbird.jpg',
    'Queen of Cups': 'Ladybug.jpg',
    'King of Cups': 'Shark.jpg',
    
    // Swords
    'Ace of Swords': 'Gecko.jpg',
    'Two of Swords': 'Penguin.jpg',
    'Three of Swords': 'BlackSwan.jpg',
    'Four of Swords': 'SnowLeopard.jpg',
    'Five of Swords': 'Hyena.jpg',
    'Six of Swords': 'Albatross.jpg',
    'Seven of Swords': 'Crow.jpg',
    'Eight of Swords': 'Moth.jpg',
    'Nine of Swords': 'Racoon.jpg',
    'Ten of Swords': 'Porcupine.jpg',
    'Page of Swords': 'Parrot.jpg',
    'Knight of Swords': 'Panther.jpg',
    'Queen of Swords': 'Vixen.jpg',
    'King of Swords': 'Lynx.jpg',
    
    // Pentacles
    'Ace of Pentacles': 'Bull.jpg',
    'Two of Pentacles': 'Monkey.jpg',
    'Three of Pentacles': 'Beaver.jpg',
    'Four of Pentacles': 'Squirrel.jpg',
    'Five of Pentacles': 'Frog.jpg',
    'Six of Pentacles': 'Golden Retriever.jpg',
    'Seven of Pentacles': 'Badger.jpg',
    'Eight of Pentacles': 'Spider.jpg',
    'Nine of Pentacles': 'Peacock.jpg',
    'Ten of Pentacles': 'Ants.jpg',
    'Page of Pentacles': 'RedPanda.jpg',
    'Knight of Pentacles': 'Ox.jpg',
    'Queen of Pentacles': 'Hen.jpg',
    'King of Pentacles': 'Bison.jpg',
  };

  // Get image path for a card
  static String getCardImagePath(TarotCard card) {
    debugPrint('🔍 ImageService: Looking up image for card "${card.name}"');
    final imageFile = _cardImageMap[card.name];
    if (imageFile != null) {
      final path = '$_basePath$imageFile';
      debugPrint('✅ ImageService: Found mapping "${card.name}" -> "$imageFile"');
      debugPrint('📁 ImageService: Full path: $path');
      return path;
    }
    // Fallback to animal name if exact match not found
    final fallbackPath = '$_basePath${card.animal}.jpg';
    debugPrint('⚠️ ImageService: No mapping found for "${card.name}", using fallback: $fallbackPath');
    return fallbackPath;
  }

  // Get image path by card name
  static String getImagePathByCardName(String cardName) {
    final imageFile = _cardImageMap[cardName];
    if (imageFile != null) {
      return '$_basePath$imageFile';
    }
    return '$_basePath$cardName.jpg';
  }

  // Check if image exists
  static bool imageExists(String imagePath) {
    try {
      return File(imagePath).existsSync();
    } catch (e) {
      return false;
    }
  }

  // Get all available image paths
  static List<String> getAllImagePaths() {
    return _cardImageMap.values.map((filename) => '$_basePath$filename').toList();
  }

  // Get card names that have images
  static List<String> getCardsWithImages() {
    return _cardImageMap.keys.toList();
  }
} 