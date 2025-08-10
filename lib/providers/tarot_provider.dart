import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tarot_card.dart';
import '../models/reading.dart';
import '../services/tarot_service.dart';
import '../data/card_data.dart';

class TarotProvider with ChangeNotifier {
  List<Reading> _readingHistory = [];
  TarotCard? _dailyCard;
  DateTime? _lastDailyCardDate;
  bool _isLoading = false;

  // Getters
  List<Reading> get readingHistory => _readingHistory;
  TarotCard? get dailyCard => _dailyCard;
  DateTime? get lastDailyCardDate => _lastDailyCardDate;
  bool get isLoading => _isLoading;

  TarotProvider() {
    _loadData();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load reading history
      final historyJson = prefs.getString('reading_history');
      if (historyJson != null) {
        final List<dynamic> historyList = json.decode(historyJson);
        _readingHistory = historyList
            .map((item) => Reading.fromMap(item))
            .toList();
      }

      // Load daily card
      final dailyCardId = prefs.getInt('daily_card_id');
      final dailyCardDate = prefs.getString('daily_card_date');
      
      if (dailyCardId != null && dailyCardDate != null) {
        _dailyCard = TarotService.getCardById(dailyCardId);
        _lastDailyCardDate = DateTime.parse(dailyCardDate);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save reading history
      final historyJson = json.encode(
        _readingHistory.map((reading) => reading.toMap()).toList(),
      );
      await prefs.setString('reading_history', historyJson);

      // Save daily card
      if (_dailyCard != null && _lastDailyCardDate != null) {
        await prefs.setInt('daily_card_id', _dailyCard!.id);
        await prefs.setString('daily_card_date', _lastDailyCardDate!.toIso8601String());
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Get or create daily card
  Future<TarotCard> getDailyCard() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if we need a new daily card
    if (_lastDailyCardDate == null || 
        _lastDailyCardDate!.isBefore(todayDate)) {
      _dailyCard = TarotService.getDailyCard();
      _lastDailyCardDate = todayDate;
      await _saveData();
      notifyListeners();
    }

    return _dailyCard ?? TarotService.getDailyCard();
  }

  // Perform a single card reading
  Future<Reading> performSingleCardReading({String? question}) async {
    _setLoading(true);
    
    try {
      final card = TarotService.drawSingleCard();
      final reading = Reading(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'single',
        cards: [card],
        timestamp: DateTime.now(),
        question: question,
      );

      _readingHistory.insert(0, reading);
      await _saveData();
      notifyListeners();
      
      return reading;
    } finally {
      _setLoading(false);
    }
  }

  // Perform a three card reading
  Future<Reading> performThreeCardReading({String? question}) async {
    _setLoading(true);
    
    try {
      final cards = TarotService.threeCardSpread();
      final reading = Reading(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'three_card',
        cards: cards,
        timestamp: DateTime.now(),
        question: question,
      );

      _readingHistory.insert(0, reading);
      await _saveData();
      notifyListeners();
      
      return reading;
    } finally {
      _setLoading(false);
    }
  }

  // Perform a Celtic Cross reading
  Future<Reading> performCelticCrossReading({String? question}) async {
    _setLoading(true);
    
    try {
      final cards = TarotService.celticCrossSpread();
      final reading = Reading(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'celtic_cross',
        cards: cards,
        timestamp: DateTime.now(),
        question: question,
      );

      _readingHistory.insert(0, reading);
      await _saveData();
      notifyListeners();
      
      return reading;
    } finally {
      _setLoading(false);
    }
  }

  // Perform a daily card reading
  Future<Reading> performDailyCardReading() async {
    _setLoading(true);
    
    try {
      final dailyCard = await getDailyCard();
      final card = ReadingCard(
        card: dailyCard,
        isReversed: false,
        position: 'Daily Guidance',
      );
      
      final reading = Reading(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'daily',
        cards: [card],
        timestamp: DateTime.now(),
        question: 'What guidance do I need today?',
      );

      _readingHistory.insert(0, reading);
      await _saveData();
      notifyListeners();
      
      return reading;
    } finally {
      _setLoading(false);
    }
  }

  // Search cards
  List<TarotCard> searchCards(String query) {
    if (query.isEmpty) return [];
    return TarotService.searchCards(query);
  }

  // Get cards by suit
  List<TarotCard> getCardsBySuit(String suit) {
    return TarotService.getCardsBySuit(suit);
  }

  // Get major arcana
  List<TarotCard> getMajorArcana() {
    return TarotService.getMajorArcana();
  }

  // Get minor arcana
  List<TarotCard> getMinorArcana() {
    return TarotService.getMinorArcana();
  }

  // Get all cards
  List<TarotCard> getAllCards() {
    return TarotService.getAllCards();
  }

  // Get a specific reading by ID
  Reading? getReadingById(String id) {
    try {
      return _readingHistory.firstWhere((reading) => reading.id == id);
    } catch (e) {
      return null;
    }
  }

  // Delete a reading
  Future<void> deleteReading(String id) async {
    _readingHistory.removeWhere((reading) => reading.id == id);
    await _saveData();
    notifyListeners();
  }

  // Clear all reading history
  Future<void> clearHistory() async {
    _readingHistory.clear();
    await _saveData();
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get reading statistics
  Map<String, int> getReadingStats() {
    Map<String, int> stats = {
      'total': _readingHistory.length,
      'single': 0,
      'three_card': 0,
      'celtic_cross': 0,
      'daily': 0,
    };

    for (Reading reading in _readingHistory) {
      stats[reading.type] = (stats[reading.type] ?? 0) + 1;
    }

    return stats;
  }

  // Get recent readings (last 10)
  List<Reading> getRecentReadings() {
    return _readingHistory.take(10).toList();
  }
} 