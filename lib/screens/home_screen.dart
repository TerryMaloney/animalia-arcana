import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tarot_provider.dart';
import '../widgets/tarot_card_widget.dart';
import '../models/tarot_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TarotCard? _dailyCard;
  bool _isLoadingDailyCard = false;

  @override
  void initState() {
    super.initState();
    _loadDailyCard();
  }

  Future<void> _loadDailyCard() async {
    setState(() {
      _isLoadingDailyCard = true;
    });

    try {
      final provider = Provider.of<TarotProvider>(context, listen: false);
      final dailyCard = await provider.getDailyCard();
      setState(() {
        _dailyCard = dailyCard;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoadingDailyCard = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animalia Arcana',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_stories,
                size: 80,
                color: Color(0xFFFFD700),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Animalia Arcana',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Discover the wisdom of animal spirits through tarot',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Daily Card Section
              GestureDetector(
                behavior: HitTestBehavior.translucent, // FIXES WEB CLICKS
                onTap: () {
                  print('🔄 Daily card tapped');
                  _showDailyCardDetail(_dailyCard!);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1B69).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Daily Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_dailyCard != null)
                        TarotCardWidget(
                          card: _dailyCard!,
                          width: 80,
                          height: 120,
                          isInteractive: false,
                        )
                      else
                        const CircularProgressIndicator(
                          color: Color(0xFFFFD700),
                          strokeWidth: 2,
                        ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap to reveal today\'s guidance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent, // FIXES WEB CLICKS
                      onTap: () {
                        print('🔄 Quick Reading button pressed');
                        _navigateToReadings(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D1B69).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.auto_stories,
                              color: Color(0xFFFFD700),
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Quick Reading',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent, // FIXES WEB CLICKS
                      onTap: () {
                        print('🔄 Card Gallery button pressed');
                        _navigateToGallery(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D1B69).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.photo_library,
                              color: Color(0xFFFFD700),
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Card Gallery',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B69).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFFFFD700),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToReadings(BuildContext context) {
    print('🔄 Navigating to readings...');
    // Use a simpler approach - just show a message for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to Readings tab'),
        backgroundColor: Color(0xFF2D1B69),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Try to find the parent MainScreen and update its index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainScreen = context.findAncestorStateOfType<_MainScreenState>();
      if (mainScreen != null) {
        print('✅ Found MainScreen, updating to index 1');
        mainScreen.updateIndex(1); // Readings tab index
      } else {
        print('❌ MainScreen not found');
      }
    });
  }

  void _navigateToGallery(BuildContext context) {
    print('🔄 Navigating to gallery...');
    // Use a simpler approach - just show a message for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to Gallery tab'),
        backgroundColor: Color(0xFF2D1B69),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Try to find the parent MainScreen and update its index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainScreen = context.findAncestorStateOfType<_MainScreenState>();
      if (mainScreen != null) {
        print('✅ Found MainScreen, updating to index 2');
        mainScreen.updateIndex(2); // Gallery tab index
      } else {
        print('❌ MainScreen not found');
      }
    });
  }

  void _showDailyCardDetail(TarotCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Text(
          card.displayName,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Keywords: ${card.keywords}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Upright Meaning:',
                style: TextStyle(
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
        ],
      ),
    );
  }
}

// Helper class to access MainScreen state
class _MainScreenState {
  void updateIndex(int index) {
    // This will be implemented in the actual MainScreen
  }
} 