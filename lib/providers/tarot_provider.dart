import 'package:flutter/foundation.dart';
import '../models/tarot_card.dart';
import '../models/reading.dart';
import '../services/tarot_service.dart';

class TarotProvider with ChangeNotifier {
  final TarotService _tarotService = TarotService();
  
  List<TarotCard> _allCards = [];
  final List<Reading> _readingHistory = [];
  bool _isLoading = false;
  String? _error;

  List<TarotCard> get allCards => _allCards;
  List<Reading> get readingHistory => _readingHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCards() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allCards = TarotService.getAllCards();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Reading> performReading(String type, String question) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final reading = await _tarotService.performReading(type, question);
      _readingHistory.insert(0, reading);
      _isLoading = false;
      notifyListeners();
      return reading;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<TarotCard> getDailyCard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final card = TarotService.getDailyCard();
      _isLoading = false;
      notifyListeners();
      return card;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  List<TarotCard> getMajorArcana() {
    return TarotService.getMajorArcana();
  }

  List<TarotCard> getAllCards() {
    return TarotService.getAllCards();
  }

  List<TarotCard> getCardsBySuit(String suit) {
    return TarotService.getCardsBySuit(suit);
  }

  List<TarotCard> searchCards(String query) {
    return TarotService.searchCards(query);
  }

  void deleteReading(String readingId) {
    _readingHistory.removeWhere((reading) => reading.id == readingId);
    notifyListeners();
  }

  Map<String, int> getReadingStats() {
    final stats = <String, int>{};
    for (final reading in _readingHistory) {
      stats[reading.type] = (stats[reading.type] ?? 0) + 1;
    }
    return stats;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearHistory() {
    _readingHistory.clear();
    notifyListeners();
  }
}
