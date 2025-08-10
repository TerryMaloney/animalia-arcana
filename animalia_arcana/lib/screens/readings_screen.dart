import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../widgets/card_reveal.dart';
import '../sound/sound_manager.dart';

class ReadingsScreen extends StatefulWidget {
  const ReadingsScreen({super.key});

  @override
  State<ReadingsScreen> createState() => _ReadingsScreenState();
}

class _ReadingsScreenState extends State<ReadingsScreen> with TickerProviderStateMixin {
  bool _showRitual = false;
  bool _skipAnimations = false;
  final List<AnimationController> _controllers = [];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _prepareAnimations(int count) {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
    for (int i = 0; i < count; i++) {
      _controllers.add(AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 280),
      ));
    }
  }

  Future<void> _runStaggered() async {
    if (!mounted) return;
    if (_controllers.isEmpty) return;
    unawaited(SoundManager.play('chime'));
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].forward();
      if (_skipAnimations) continue;
      await Future.delayed(const Duration(milliseconds: 1200));
    }
  }

  void _startDraw(DeckProvider deck) {
    setState(() {
      _showRitual = true;
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        final theme = deck.themeManager;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            setState(() => _showRitual = false);
            deck.shuffleDeck();
            final result = deck.drawSpread();
            _prepareAnimations(result.length);
            WidgetsBinding.instance.addPostFrameCallback((_) => _runStaggered());
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.background.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.secondary.withOpacity(0.6)),
              ),
              width: 340,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFFFD700), size: 36),
                  SizedBox(height: 12),
                  Text(
                    'Focus on your question.\nTake a breath.\nTap when you\'re ready.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckProvider>(
      builder: (context, deck, _) {
        final cards = deck.currentSpread;
        final spread = deck.activeSpread;
        final theme = deck.themeManager;
        final width = MediaQuery.sizeOf(context).width;
        final isNarrow = width < 520;

        return Scaffold(
          backgroundColor: theme.background,
          appBar: AppBar(
            backgroundColor: theme.background,
            title: Text(
              'Tarot Readings',
              style: TextStyle(
                color: theme.secondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => setState(() => _skipAnimations = true),
                child: const Text('Skip animation', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 1.3,
                colors: [theme.primary.withOpacity(0.10), theme.background],
                stops: const [0.0, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: deck.activeDeck?.id,
                          items: deck.decks
                              .map((d) => DropdownMenuItem<String>(
                                    value: d.id,
                                    child: Text(d.name),
                                  ))
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Deck',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFD700)),
                            ),
                          ),
                          dropdownColor: theme.background,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) async {
                            if (value != null) {
                              await deck.setDeck(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: deck.isLoading ? null : () => _startDraw(deck),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondary,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Draw'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (spread != null) ...[
                    Text(
                      spread.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Expanded(
                    child: cards.isEmpty
                        ? const Center(
                            child: Text(
                              'No cards drawn yet. Choose deck and tap Draw.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final axisCount = isNarrow ? 1 : (cards.length == 3 ? 3 : 2);
                              return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: axisCount,
                                  childAspectRatio: isNarrow ? 0.68 : 0.74,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: cards.length,
                                itemBuilder: (context, index) {
                                  final card = cards[index];
                                  final controller = index < _controllers.length ? _controllers[index] : null;
                                  final animation = controller?.drive(
                                    CurveTween(curve: Curves.easeOutCubic),
                                  ).drive(
                                    Tween<double>(begin: 0.85, end: 1.0),
                                  );

                                  final position = spread?.positions[index] ?? 'Card ${index + 1}';
                                  final meaning = spread?.positionMeanings != null &&
                                          spread!.positionMeanings!.length > index
                                      ? spread.positionMeanings![index]
                                      : null;

                                  Widget content = Container(
                                    decoration: BoxDecoration(
                                      color: theme.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.secondary.withOpacity(0.25),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 4),
                                        Expanded(child: CardReveal(card: card, animationType: RevealAnimationType.fade)),
                                        const SizedBox(height: 6),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            position,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (meaning != null) ...[
                                          const SizedBox(height: 2),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              meaning,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white38,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  );

                                  if (_skipAnimations || controller == null) {
                                    return content;
                                  }

                                  return FadeTransition(
                                    opacity: controller.drive(Tween<double>(begin: 0.0, end: 1.0)),
                                    child: ScaleTransition(
                                      scale: animation!,
                                      child: content,
                                    ),
                                  );
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
      },
    );
  }
}