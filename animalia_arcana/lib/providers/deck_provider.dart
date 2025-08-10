import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/deck.dart';
import '../models/spread.dart';
import '../theme/theme_manager.dart';

class DeckProvider extends ChangeNotifier {
  DeckProvider({ThemeManager? themeManager}) : _themeManager = themeManager ?? ThemeManager() {
    _init();
  }

  final ThemeManager _themeManager;

  // Loaded content
  final List<DeckModel> _decks = <DeckModel>[];
  final List<SpreadModel> _spreads = <SpreadModel>[];

  // Active selections
  DeckModel? _activeDeck;
  SpreadModel? _activeSpread;

  // Working state
  late List<CardDataModel> _shuffled;
  List<CardDataModel> _currentSpread = <CardDataModel>[];
  bool _isLoading = false;

  // Getters
  List<DeckModel> get decks => List.unmodifiable(_decks);
  List<SpreadModel> get spreads => List.unmodifiable(_spreads);
  DeckModel? get activeDeck => _activeDeck;
  SpreadModel? get activeSpread => _activeSpread;
  List<CardDataModel> get currentSpread => List.unmodifiable(_currentSpread);
  bool get isLoading => _isLoading;
  ThemeManager get themeManager => _themeManager;

  Future<void> _init() async {
    _setLoading(true);
    await Future.wait([
      _loadDecksFromAssets(),
      _loadSpreadsFromAssets(),
    ]);

    // Default selections
    _activeDeck = _decks.firstWhere(
      (d) => d.id == 'animal_tarot',
      orElse: () => _decks.isNotEmpty ? _decks.first : DeckModel(id: 'empty', name: 'Empty', cards: const []),
    );
    _activeSpread = _spreads.firstWhere(
      (s) => s.id == 'three_card',
      orElse: () => _spreads.isNotEmpty
          ? _spreads.first
          : const SpreadModel(id: 'fallback', name: 'Three', cardCount: 3, positions: ['1', '2', '3']),
    );

    await _themeManager.loadThemeForDeck(_activeDeck!.id);

    _shuffled = List<CardDataModel>.from(_activeDeck?.cards ?? const []);
    _shuffled.shuffle();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _loadDecksFromAssets() async {
    final candidates = <String>[
      'assets/decks/animal_tarot.json',
    ];
    _decks.clear();
    for (final path in candidates) {
      try {
        final jsonStr = await rootBundle.loadString(path);
        final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
        _decks.add(DeckModel.fromJson(jsonMap));
      } catch (e) {
        if (kDebugMode) {
          print('DeckProvider: Failed to load deck $path: $e');
        }
      }
    }
  }

  Future<void> _loadSpreadsFromAssets() async {
    final candidates = <String>[
      'assets/spreads/three_card.json',
    ];
    _spreads.clear();
    for (final path in candidates) {
      try {
        final jsonStr = await rootBundle.loadString(path);
        final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
        _spreads.add(SpreadModel.fromJson(jsonMap));
      } catch (e) {
        if (kDebugMode) {
          print('DeckProvider: Failed to load spread $path: $e');
        }
      }
    }
  }

  // Public API
  Future<void> setDeck(String deckId) async {
    final match = _decks.where((d) => d.id == deckId).toList();
    if (match.isEmpty) return;
    _activeDeck = match.first;
    _shuffled = List<CardDataModel>.from(_activeDeck!.cards);
    _shuffled.shuffle();
    _currentSpread = <CardDataModel>[];
    await _themeManager.loadThemeForDeck(deckId);
    notifyListeners();
  }

  void shuffleDeck() {
    _shuffled.shuffle();
    notifyListeners();
  }

  CardDataModel drawCard() {
    if (_shuffled.isEmpty) {
      _shuffled = List<CardDataModel>.from(_activeDeck?.cards ?? const []);
      _shuffled.shuffle();
    }
    final card = _shuffled.removeAt(0);
    notifyListeners();
    return card;
  }

  List<CardDataModel> drawSpread([int? count]) {
    final target = count ?? _activeSpread?.cardCount ?? 3;
    if (_shuffled.length < target) {
      _shuffled = List<CardDataModel>.from(_activeDeck?.cards ?? const []);
      _shuffled.shuffle();
    }
    _currentSpread = _shuffled.take(target).toList(growable: false);
    _shuffled = _shuffled.skip(target).toList(growable: true);

    // Analytics hook
    logReading(_activeDeck?.id ?? 'unknown', _activeSpread?.id ?? 'unknown');

    notifyListeners();
    return _currentSpread;
  }

  // Analytics hook (stub)
  void logReading(String deckId, String spreadId) {
    if (kDebugMode) {
      debugPrint('📊 Reading logged for deckId: $deckId, spreadId: $spreadId');
    }
    // TODO: integrate actual analytics provider
  }
}