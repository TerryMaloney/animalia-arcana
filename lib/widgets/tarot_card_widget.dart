import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import '../models/reading.dart';
import '../services/image_service.dart';
import 'platform_aware_image.dart';

class TarotCardWidget extends StatelessWidget {
  final TarotCard card;
  final bool isReversed;
  final bool isInteractive;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showDetails;

  const TarotCardWidget({
    super.key,
    required this.card,
    this.isReversed = false,
    this.isInteractive = true,
    this.onTap,
    this.width,
    this.height,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = ImageService.getCardImagePath(card);
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // FIXES WEB CLICKS
      onTap: isInteractive ? () {
        debugPrint('🔄 Card tapped: ${card.name}');
        onTap?.call();
      } : null,
      child: Container(
        width: width ?? 120,
        height: height ?? 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFD700).withValues(alpha: 0.1),
              const Color(0xFF2D1B69).withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFFFD700).withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x80FFD700),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            children: [
              // Card background pattern
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF2D1B69).withValues(alpha: 0.8),
                      const Color(0xFF0A0A0A).withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),

              // Card content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card image with platform-aware loading
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: PlatformAwareAssetImage(
                          asset: imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Card name
                    Text(
                      card.name,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Animal name
                    Text(
                      card.animal,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (showDetails) ...[
                      const SizedBox(height: 4),

                      // Orientation indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isReversed
                              ? Colors.red.withValues(alpha: 0.3)
                              : const Color(0xFFFFD700).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isReversed ? 'Reversed' : 'Upright',
                          style: TextStyle(
                            fontSize: 6,
                            color: isReversed ? Colors.red[300] : const Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Reversed indicator overlay
              if (isReversed)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Transform.rotate(
                    angle: 3.14159, // 180 degrees
                    child: Icon(
                      Icons.rotate_right,
                      size: 16,
                      color: Colors.red[300],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReadingCardWidget extends StatelessWidget {
  final ReadingCard readingCard;
  final bool isInteractive;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ReadingCardWidget({
    super.key,
    required this.readingCard,
    this.isInteractive = true,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return TarotCardWidget(
      card: readingCard.card,
      isReversed: readingCard.orientation == 'reversed',
      isInteractive: isInteractive,
      onTap: onTap,
      width: width,
      height: height,
    );
  }
}

class CardDetailWidget extends StatelessWidget {
  final TarotCard card;
  final bool isReversed;
  final String? position;

  const CardDetailWidget({
    super.key,
    required this.card,
    this.isReversed = false,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Card header
          Row(
            children: [
              TarotCardWidget(
                card: card,
                isReversed: isReversed,
                isInteractive: false,
                width: 80,
                height: 120,
                showDetails: false,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isReversed ? 'Reversed' : 'Upright',
                      style: TextStyle(
                        fontSize: 14,
                        color: isReversed ? Colors.red[300] : const Color(0xFFFFD700),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (position != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        position!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Keywords
          const Text(
            'Keywords',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.keywords,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // Meaning
          const Text(
            'Meaning',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isReversed ? card.reversedMeaning : card.uprightMeaning,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
} 