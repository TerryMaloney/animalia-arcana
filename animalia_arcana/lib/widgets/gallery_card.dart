import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../utils/asset_resolver.dart';

class GalleryCard extends StatefulWidget {
  const GalleryCard({super.key, required this.card, required this.index});

  final CardDataModel card;
  final int index;

  @override
  State<GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<GalleryCard> {
  bool _loggedResolvedPath = false;
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<String>(
      future: AssetResolver.resolveFromFullPath(widget.card.imagePath),
      builder: (context, snapshot) {
        final hasData = snapshot.hasData && snapshot.data != null;
        final resolved = snapshot.data;

        if (hasData && !_loggedResolvedPath) {
          _loggedResolvedPath = true;
          if (kDebugMode) debugPrint('GalleryCard using $resolved');
        }

        if (hasData && !_loaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _loaded = true);
          });
        }

        return AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image or placeholder
                Center(
                  child: hasData
                      ? AnimatedOpacity(
                          opacity: _loaded ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          child: Image.asset(
                            resolved!, // relative key from AssetResolver
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const _PlaceholderCard(),
                          ),
                        )
                      : const _PlaceholderCard(),
                ),
                // Bottom ribbon label
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
                          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white) ??
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.index + 1}',
                          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70) ??
                              const TextStyle(color: Colors.white70, fontSize: 11),
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

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF2D1B69),
      alignment: Alignment.center,
      child: const Icon(Icons.image, size: 40, color: Color(0xFFFFD700)),
    );
  }
}