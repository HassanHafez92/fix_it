import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int duration; // in minutes
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        price,
        duration,
        images,
        rating,
        reviewCount,
        isAvailable,
      ];

  factory ServiceEntity.fromJson(Map<String, dynamic> json) {
    return ServiceEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      images: List<String>.from(json['images']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'duration': duration,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
    };
  }
}
