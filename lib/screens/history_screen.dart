import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tarot_provider.dart';
import '../widgets/tarot_card_widget.dart';
import '../models/reading.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reading History',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFFFFD700)),
            onPressed: () => _showFilterDialog(context),
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
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<TarotProvider>(
                builder: (context, provider, child) {
                  final stats = provider.getReadingStats();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Past Readings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D1B69).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${stats['total'] ?? 0} Readings',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<TarotProvider>(
                  builder: (context, provider, child) {
                    if (provider.readingHistory.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No readings yet',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Perform your first reading to see it here',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: provider.readingHistory.length,
                      itemBuilder: (context, index) {
                        final reading = provider.readingHistory[index];
                        return _buildHistoryItem(context, reading);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Reading reading) {
    return GestureDetector(
      onTap: () => _showReadingDetail(context, reading),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B69).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getReadingIcon(reading.type),
                    size: 24,
                    color: const Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reading.displayType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        reading.formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Display cards
            if (reading.cards.length <= 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: reading.cards.map((card) => 
                  ReadingCardWidget(
                    readingCard: card,
                    isInteractive: false,
                    width: 60,
                    height: 90,
                  ),
                ).toList(),
              )
            else
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: reading.cards.take(6).map((card) => 
                  ReadingCardWidget(
                    readingCard: card,
                    isInteractive: false,
                    width: 40,
                    height: 60,
                  ),
                ).toList(),
              ),
            
            const SizedBox(height: 15),
            
            // Reading summary
            Text(
              _getReadingSummary(reading),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 15),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${reading.cards.length} cards',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Saved',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReadingIcon(String type) {
    switch (type) {
      case 'single':
        return Icons.crop_square;
      case 'three_card':
        return Icons.view_column;
      case 'celtic_cross':
        return Icons.grid_on;
      case 'daily':
        return Icons.wb_sunny;
      default:
        return Icons.auto_stories;
    }
  }

  String _getReadingSummary(Reading reading) {
    if (reading.cards.isEmpty) return 'No cards in this reading.';
    
    final cardNames = reading.cards.map((card) => card.card.shortName).join(', ');
    return 'Cards: $cardNames';
  }

  void _showReadingDetail(BuildContext context, Reading reading) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Text(
          reading.displayType,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reading info
              Text(
                'Date: ${reading.formattedDate}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              if (reading.question.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'Question: ${reading.question}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              
              // Cards
              const Text(
                'Cards Drawn:',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              
              // Display cards in a grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: reading.cards.length,
                itemBuilder: (context, index) {
                  final card = reading.cards[index];
                  return Column(
                    children: [
                      ReadingCardWidget(
                        readingCard: card,
                        isInteractive: false,
                        width: 60,
                        height: 90,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        card.position.isNotEmpty ? card.position : 'Card ${index + 1}',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Interpretation
              const Text(
                'Interpretation:',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _getReadingInterpretation(reading),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<TarotProvider>(context, listen: false);
              provider.deleteReading(reading.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reading deleted'),
                  backgroundColor: Color(0xFF2D1B69),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _getReadingInterpretation(Reading reading) {
    switch (reading.type) {
      case 'single':
        return reading.cards.first.meaning;
      case 'three_card':
        return 'Past: ${reading.cards[0].card.displayName} (${reading.cards[0].orientation})\n'
               '${reading.cards[0].meaning}\n\n'
               'Present: ${reading.cards[1].card.displayName} (${reading.cards[1].orientation})\n'
               '${reading.cards[1].meaning}\n\n'
               'Future: ${reading.cards[2].card.displayName} (${reading.cards[2].orientation})\n'
               '${reading.cards[2].meaning}';
      case 'celtic_cross':
        return 'Your Celtic Cross reading reveals deep insights into your situation. '
               'Each card represents a different aspect of your journey.';
      case 'daily':
        return reading.cards.first.meaning;
      default:
        return 'Your reading reveals important guidance for your path.';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Filter Readings',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Filter functionality coming soon...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        actions: [
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
} 