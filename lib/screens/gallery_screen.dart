import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tarot_provider.dart';
import '../widgets/tarot_card_widget.dart';
import '../models/tarot_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _selectedSuit = 'major_arcana';
  String _searchQuery = '';
  List<TarotCard> _filteredCards = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredCards();
  }

  void _updateFilteredCards() {
    final provider = Provider.of<TarotProvider>(context, listen: false);

    List<TarotCard> cards;
    if (_selectedSuit == 'major_arcana') {
      cards = provider.getMajorArcana();
    } else if (_selectedSuit == 'all') {
      cards = provider.getAllCards();
    } else {
      cards = provider.getCardsBySuit(_selectedSuit);
    }

    if (_searchQuery.isNotEmpty) {
      cards = provider.searchCards(_searchQuery);
    }

    setState(() {
      _filteredCards = cards;
    });
    
    // Debug: Print first few cards to verify data
    if (cards.isNotEmpty) {
      print('Gallery: Loaded ${cards.length} cards');
      print('First card: ${cards.first.name} - ${cards.first.animal}');
      print('First card image path: ${cards.first.imagePath}');
      
      // Test image loading for first few cards
      for (int i = 0; i < 3 && i < cards.length; i++) {
        final card = cards[i];
        print('Card ${i + 1}: ${card.name} -> ${card.imagePath}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Card Gallery',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFFFD700)),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF2D1B69),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Suit filter tabs
              _buildSuitTabs(),
              const SizedBox(height: 20),

              // Search results info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getSuitDisplayName(_selectedSuit),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D1B69).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${_filteredCards.length} Cards',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cards grid
              Expanded(
                child: _filteredCards.isEmpty
                    ? const Center(
                        child: Text(
                          'No cards found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _filteredCards.length,
                        itemBuilder: (context, index) {
                          return _buildCardItem(_filteredCards[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuitTabs() {
    final suits = [
      {'id': 'major_arcana', 'name': 'Major Arcana'},
      {'id': 'wands', 'name': 'Wands'},
      {'id': 'cups', 'name': 'Cups'},
      {'id': 'swords', 'name': 'Swords'},
      {'id': 'pentacles', 'name': 'Pentacles'},
      {'id': 'all', 'name': 'All'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: suits.map((suit) {
          final isSelected = _selectedSuit == suit['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSuit = suit['id']!;
                });
                _updateFilteredCards();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFD700).withOpacity(0.3)
                      : const Color(0xFF2D1B69).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFD700)
                        : const Color(0xFFFFD700).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  suit['name']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? const Color(0xFFFFD700)
                        : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCardItem(TarotCard card) {
    print('🔄 Building card item: ${card.name}');
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // FIXES WEB CLICKS
      onTap: () {
        print('🔄 Gallery card tapped: ${card.name}');
        _showCardDetail(card);
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B69).withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: TarotCardWidget(
          card: card,
          width: 100,
          height: 150,
          isInteractive: false,
        ),
      ),
    );
  }

  void _showCardDetail(TarotCard card) {
    print('🔄 Showing card detail for: ${card.name}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Text(
          card.displayName,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TarotCardWidget(
                card: card,
                width: 120,
                height: 180,
                isInteractive: false,
              ),
              const SizedBox(height: 20),
              Text(
                'Upright Meaning:',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                card.uprightMeaning,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reversed Meaning:',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                card.reversedMeaning,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('🔄 Card detail dialog closed');
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Search Cards',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search by card name or animal...',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFD700)),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _updateFilteredCards();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
              _updateFilteredCards();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }

  String _getSuitDisplayName(String suit) {
    switch (suit) {
      case 'major_arcana':
        return 'Major Arcana';
      case 'wands':
        return 'Wands';
      case 'cups':
        return 'Cups';
      case 'swords':
        return 'Swords';
      case 'pentacles':
        return 'Pentacles';
      case 'all':
        return 'All Cards';
      default:
        return 'Cards';
    }
  }
} 