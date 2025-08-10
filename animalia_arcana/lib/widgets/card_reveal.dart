import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/asset_resolver.dart';

enum RevealAnimationType { fade, flip, slide, none }

class CardReveal extends StatefulWidget {
  final CardDataModel card;
  final RevealAnimationType animationType;

  const CardReveal({
    super.key,
    required this.card,
    this.animationType = RevealAnimationType.none,
  });

  @override
  State<CardReveal> createState() => _CardRevealState();
}

class _CardRevealState extends State<CardReveal> {
  bool _loggedResolvedPath = false;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('✨ Revealing card: ${widget.card.name} with animation: ${widget.animationType}');
    }
    final theme = Theme.of(context);
    return FutureBuilder<String>(
      future: AssetResolver.resolveFromFullPath(widget.card.imagePath),
      builder: (context, snapshot) {
        final resolvedPath = snapshot.data;
        if (!_loggedResolvedPath && resolvedPath != null) {
          _loggedResolvedPath = true;
          if (kDebugMode) debugPrint('CardReveal using $resolvedPath');
        }
        return AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image or placeholder
                if (resolvedPath == null)
                  Container(
                    color: const Color(0xFF2D1B69),
                    child: const Icon(Icons.image, color: Colors.white54),
                  )
                else
                  Image.asset(
                    resolvedPath, // DO NOT prepend 'assets/'
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Container(
                      color: const Color(0xFF2D1B69),
                      child: const Icon(Icons.image_not_supported, color: Colors.white54),
                    ),
                  ),
                // Bottom overlay ribbon
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    color: Colors.black.withValues(alpha: 0.45),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.card.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white) ??
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.card.meaning,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70) ??
                              const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}