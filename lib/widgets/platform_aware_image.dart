import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAwareAssetImage extends StatelessWidget {
  const PlatformAwareAssetImage({
    Key? key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Primary web path attempt
      return Image.network(
        'assets/$asset',
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Primary web path failed: assets/$asset');
          // Fallback for double assets folder issue
          return Image.network(
            'assets/assets/$asset',
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('❌ Fallback web path failed: assets/assets/$asset');
              // Final fallback with card info
              return Container(
                width: width ?? 150,
                height: height ?? 225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D1B69), Color(0xFF0A0A0A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
                    SizedBox(height: 8),
                    // Non-const text replaced nearer usage sites where data is known
                    // Keep as const structure containers
                  ],
                ),
              );
            },
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            debugPrint('✅ Image loaded successfully: assets/$asset');
            return child;
          }
          debugPrint('⏳ Loading image: ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}');
          return Container(
            width: width,
            height: height,
            color: const Color(0xFF2D1B69).withValues(alpha: 0.3),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / 
                      loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.amber,
              ),
            ),
          );
        },
      );
    }
    
    // Standard mobile asset loading
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Mobile asset loading failed: $asset');
        return Container(
          width: width ?? 150,
          height: height ?? 225,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber, width: 2),
            gradient: const LinearGradient(
              colors: [Color(0xFF2D1B69), Color(0xFF0A0A0A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
              SizedBox(height: 8),
              // Omit dynamic texts here to keep const friendliness
            ],
          ),
        );
      },
    );
  }

  // (helpers removed)
} 