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
          print('❌ Primary web path failed: assets/$asset');
          // Fallback for double assets folder issue
          return Image.network(
            'assets/assets/$asset',
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              print('❌ Fallback web path failed: assets/assets/$asset');
              // Final fallback with card info
              return Container(
                width: width ?? 150,
                height: height ?? 225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 2),
                  gradient: LinearGradient(
                    colors: [Color(0xFF2D1B69), Color(0xFF0A0A0A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
                    SizedBox(height: 8),
                    Text(
                      _getCardName(asset),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _getAnimalName(asset),
                      style: TextStyle(color: Colors.amber, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            print('✅ Image loaded successfully: assets/$asset');
            return child;
          }
          print('⏳ Loading image: ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}');
          return Container(
            width: width,
            height: height,
            color: Color(0xFF2D1B69).withOpacity(0.3),
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
        print('❌ Mobile asset loading failed: $asset');
        return Container(
          width: width ?? 150,
          height: height ?? 225,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber, width: 2),
            gradient: LinearGradient(
              colors: [Color(0xFF2D1B69), Color(0xFF0A0A0A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
              SizedBox(height: 8),
              Text(
                _getCardName(asset),
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              Text(
                _getAnimalName(asset),
                style: TextStyle(color: Colors.amber, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  String _getCardName(String asset) {
    final name = asset.split('/').last.split('.').first;
    switch (name) {
      case 'Butterfly': return 'The Fool';
      case 'Fox': return 'The Magician';
      case 'Owl': return 'High Priestess';
      case 'Cow': return 'The Empress';
      case 'Lion': return 'The Emperor';
      case 'Elephant': return 'The Hierophant';
      case 'Swans': return 'The Lovers';
      case 'Horse': return 'The Chariot';
      case 'Bear': return 'Strength';
      case 'Tortoise': return 'The Hermit';
      case 'Snake': return 'Wheel of Fortune';
      case 'Eagle': return 'Justice';
      case 'Bat': return 'The Hanged Man';
      case 'Scorpion': return 'Death';
      case 'Heron': return 'Temperance';
      case 'Goat': return 'The Devil';
      case 'Vulture': return 'The Tower';
      case 'Deer': return 'The Star';
      case 'Wolf': return 'The Moon';
      case 'Rooster': return 'The Sun';
      case 'Pheonix': return 'Judgement';
      case 'Whale': return 'The World';
      default: return name;
    }
  }

  String _getAnimalName(String asset) {
    return asset.split('/').last.split('.').first;
  }
} 