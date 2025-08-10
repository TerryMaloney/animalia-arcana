import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tarot_card.dart';
import '../models/reading.dart';
import '../services/tarot_service.dart';
import '../data/card_data.dart';

class TarotProvider extends ChangeNotifier {
  List<Reading> _readings = [];
  TarotCard? _dailyCard;
  bool _isLoading = false;
  String _error = '';

  List<Reading> get readings => _readings;
  TarotCard? get dailyCard => _dailyCard;
  bool get isLoading => _isLoading;
  String get error => _error;

  TarotProvider() {
    _loadReadings();
    _loadDailyCard();
  }

  Future<void> _loadReadings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readingsJson = prefs.getStringList('readings') ?? [];
      _readings = readingsJson
          .map((json) => Reading.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners();
    } catch (e) {
      print('❌ Error loading readings: $e');
      _error = 'Failed to load reading history';
      notifyListeners();
    }
  }

  Future<void> _saveReadings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readingsJson = _readings
          .map((reading) => jsonEncode(reading.toJson()))
          .toList();
      await prefs.setStringList('readings', readingsJson);
    } catch (e) {
      print('❌ Error saving readings: $e');
      _error = 'Failed to save reading';
      notifyListeners();
    }
  }

  Future<void> _loadDailyCard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastDailyDate = prefs.getString('last_daily_date');
      
      if (lastDailyDate != today) {
        // Generate new daily card
        final deck = TarotService.getShuffledDeck();
        _dailyCard = TarotService.drawCard(deck);
        await prefs.setString('daily_card', jsonEncode(_dailyCard!.toJson()));
        await prefs.setString('last_daily_date', today);
      } else {
        // Load existing daily card
        final dailyCardJson = prefs.getString('daily_card');
        if (dailyCardJson != null) {
          _dailyCard = TarotCard.fromJson(jsonDecode(dailyCardJson));
        }
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error loading daily card: $e');
      _error = 'Failed to load daily card';
      notifyListeners();
    }
  }

  Future<void> performSingleCardReading(String question) async {
    _setLoading(true);
    try {
      final reading = await TarotService.performSingleCardReading(question);
      _readings.insert(0, reading);
      await _saveReadings();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to perform single card reading: $e');
    }
  }

  Future<void> performThreeCardReading(String question) async {
    _setLoading(true);
    try {
      final reading = await TarotService.performThreeCardReading(question);
      _readings.insert(0, reading);
      await _saveReadings();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to perform three card reading: $e');
    }
  }

  Future<void> performCelticCrossReading(String question) async {
    _setLoading(true);
    try {
      final reading = await TarotService.performCelticCrossReading(question);
      _readings.insert(0, reading);
      await _saveReadings();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to perform Celtic Cross reading: $e');
    }
  }

  Future<void> performDailyReading() async {
    _setLoading(true);
    try {
      final reading = await TarotService.performDailyReading();
      _readings.insert(0, reading);
      await _saveReadings();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to perform daily reading: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _error = '';
    notifyListeners();
  }

  void _setError(String error) {
    _isLoading = false;
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  List<TarotCard> getAllCards() {
    return CardData.getAllCards();
  }

  List<TarotCard> getMajorArcana() {
    return CardData.getMajorArcana();
  }

  List<TarotCard> getMinorArcana() {
    return CardData.getMinorArcana();
  }

  void deleteReading(String readingId) {
    _readings.removeWhere((reading) => reading.id == readingId);
    _saveReadings();
  }

  void clearAllReadings() {
    _readings.clear();
    _saveReadings();
  }
} 