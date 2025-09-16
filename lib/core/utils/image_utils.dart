
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'image_cache_manager.dart';

/// A utility class for optimized image loading
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
class ImageUtils {
  /// Creates a progressive image loading widget with optimized settings
  static Widget progressiveImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget placeholder = const SizedBox.shrink(),
    Widget errorWidget = const SizedBox.shrink(),
    bool usePlaceholder = true,
    bool useErrorWidget = true,
    double? placeholderScale,
    double? errorScale,
    String? cacheKey,
    int? memCacheWidth,
    int? memCacheHeight,
    Duration? fadeInDuration,
    Color? placeholderColor,
    Color? errorColor,
    Widget? customPlaceholder,
    Widget? customErrorWidget,
  }) {
/// CachedNetworkImage
///
/// @param imageUrl 
/// @param width 
/// @param height 
/// @param fit 
/// @param url 
/// Returns: 
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) {
        if (customPlaceholder != null) return customPlaceholder;
        if (!usePlaceholder) return placeholder;

        return Container(
          width: width,
          height: height,
          color: placeholderColor ?? Colors.grey[300],
          child: Center(
            child: placeholderScale != null 
              ? Icon(Icons.image, color: Colors.grey, size: 24 * placeholderScale)
              : const Icon(Icons.image, color: Colors.grey),
          ),
        );
      },
      errorWidget: (context, url, error) {
        if (customErrorWidget != null) return customErrorWidget;
        if (!useErrorWidget) return errorWidget;

        return Container(
          width: width,
          height: height,
          color: errorColor ?? Colors.grey[200],
          child: Center(
            child: errorScale != null 
              ? Icon(Icons.build, color: Colors.grey, size: 24 * errorScale)
              : const Icon(Icons.build, color: Colors.grey),
          ),
        );
      },
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      cacheKey: cacheKey,
    );
  }

  /// Creates a thumbnail with optimized settings for list items


  /// Creates a thumbnail with optimized settings for list items
/// @param imageUrl 
/// @param width 
/// @param height 
/// @param fit 
/// @param cacheKey 
/// Returns: 
  static Widget thumbnail({
    required String imageUrl,
    double width = 60,
    double height = 60,
    BoxFit fit = BoxFit.cover,
    String? cacheKey,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: progressiveImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholderScale: 0.8,
        errorScale: 0.8,
        cacheKey: cacheKey,
        memCacheWidth: (width * 2).toInt(),
        memCacheHeight: (height * 2).toInt(),
      ),
    );
  }

  /// Creates a hero image for transitions with optimized settings


  /// Creates a hero image for transitions with optimized settings
/// @param imageUrl 
/// @param tag 
/// @param width 
/// @param height 
/// @param fit 
/// @param cacheKey 
/// Returns: 
  static Widget heroImage({
    required String imageUrl,
    required String tag,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? cacheKey,
  }) {
    return Hero(
      tag: tag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: progressiveImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholderScale: 1.0,
          errorScale: 1.0,
          cacheKey: cacheKey,
          memCacheWidth: width != null ? (width * 3).toInt() : null,
          memCacheHeight: height != null ? (height * 3).toInt() : null,
        ),
      ),
    );
  }

  /// Creates a grid image with optimized settings


  /// Creates a grid image with optimized settings
/// @param imageUrl 
/// @param width 
/// @param height 
/// @param fit 
/// @param cacheKey 
/// Returns: 
  static Widget gridImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? cacheKey,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: progressiveImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholderScale: 0.9,
        errorScale: 0.9,
        cacheKey: cacheKey,
        memCacheWidth: width != null ? (width * 2.5).toInt() : null,
        memCacheHeight: height != null ? (height * 2.5).toInt() : null,
      ),
    );
  }

  /// Preloads images for better perceived performance


  /// Preloads images for better perceived performance
/// Returns: 
  static Future<void> preloadImages(List<String> imageUrls) async {
    await ImageCacheManager.preloadImages(imageUrls);
  }

  /// Clears all image caches


  /// Clears all image caches
/// Returns: 
  static Future<void> clearAllCache() async {
    await ImageCacheManager.clearAllCache();
  }
}
