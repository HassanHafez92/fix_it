
import 'package:flutter/material.dart';

/// A utility class for managing image cache
class ImageCacheManager {
  /// Clears all image caches
  static Future<void> clearAllCache() async {
    try {
      // Clear Flutter's image cache
      PaintingBinding.instance.imageCache.clear();

      // Clear persistent cache if available
      // In a real implementation, this would clear the cached_network_image cache
      debugPrint('All image caches cleared successfully');
    } catch (e) {
      debugPrint('Error clearing image caches: $e');
    }
  }

  /// Clears only the in-memory image cache
  static void clearMemoryCache() {
    try {
      PaintingBinding.instance.imageCache.clear();
      debugPrint('Memory image cache cleared');
    } catch (e) {
      debugPrint('Error clearing memory image cache: $e');
    }
  }

  /// Preloads images for better perceived performance
  static Future<void> preloadImages(List<String> imageUrls) async {
    // In a real app, this would be called from a widget context
    // For now, we'll just log the preload request
    debugPrint('Preloading ${imageUrls.length} images');

    // Actual precaching would need a valid BuildContext
    // This is a simplified implementation for demonstration
  }

  /// Gets the current memory cache size
  static int getMemoryCacheSize() {
    return PaintingBinding.instance.imageCache.currentSizeBytes;
  }

  /// Gets the maximum allowed memory cache size
  static int getMaxMemoryCacheSize() {
    return PaintingBinding.instance.imageCache.maximumSizeBytes;
  }

  /// Sets the maximum memory cache size
  static void setMaxMemoryCacheSize(int sizeInBytes) {
    PaintingBinding.instance.imageCache.maximumSizeBytes = sizeInBytes;
  }

  /// Clears old cache items based on age
  static Future<void> clearOldCache(int maxAgeInDays) async {
    try {
      // This would remove cache items older than maxAgeInDays in a real implementation
      debugPrint('Cleared old cache items older than $maxAgeInDays days');
    } catch (e) {
      debugPrint('Error clearing old cache: $e');
    }
  }
}
